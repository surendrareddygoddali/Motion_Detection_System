package com.example.gesture_collection_app

import org.tensorflow.lite.Interpreter
import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.FileInputStream
import java.io.IOException
import java.nio.MappedByteBuffer
import java.nio.channels.FileChannel
import android.content.res.AssetFileDescriptor

import android.content.Context
import android.content.res.AssetManager

import android.widget.Toast
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import java.io.BufferedReader
import java.io.InputStreamReader
import android.app.Activity

import java.util.*

class MainActivity:FlutterActivity() {
    protected var tflite:Interpreter? = null
    private var labelList:List<String>? = null
    var result = ""
    var inputSize =  100;
    var outputSize =  11;
    var labelFileName = "labels.txt";
    var modelName = "newdatamodel.tflite"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.getDartExecutor(), CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->

            var text = call.argument<String>("data")
            println(modelName)
            text = text!!.replace("[", "")
            text = text.replace("]", "")
            val strs = text.split(",").toTypedArray()
            var gestureCoordinates = arrayOf<Array<Float>>()
            var i = 0
            for (data in strs){
                val coordinateArray = data.split(":").toTypedArray()
                val x = (coordinateArray[0]).toFloat()
                val y = (coordinateArray[1]).toFloat()
                val z = (coordinateArray[2]).toFloat()

                var array = arrayOf<Float>()
                array += x
                array += y
                array += z
                gestureCoordinates += array

            }
            if (call.method == "predictData") {

               val gestureString = predictData(gestureCoordinates)
                Toast.makeText(context, "Gesture detected: " + gestureString , Toast.LENGTH_LONG).show()
                result.success(gestureString)

            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        println("Kotlin loaded");
        try
        {
            tflite = Interpreter(loadModelFile(this))
            labelList = loadLabelList();
            println("Kotlin import of model was successful");

        }
        catch (e:Exception) {
            //TODO: handle exception
            println("Kotlin import of model was failed");
        }

    }
    // This method interact with our model and makes prediction returning value of "0" or "1".
    internal fun predictData(input_data: Array<Array<Float>>):String {
        var intArray = Array<Array<FloatArray>>(1, {Array<FloatArray>(inputSize, {FloatArray(3)})})
        for (i in 0..input_data.size-1) {
            val array =  input_data[i]
            for (j in 0..array.size-1) {
                if(i < inputSize)
                intArray[0][i][j] = array[j]
            }
         }

        var output_datas = Array<FloatArray>(1, {FloatArray(outputSize)})
        tflite?.run(intArray, output_datas)

        //println("outputTflite " + Arrays.deepToString(output_datas).replace("], ", "]\n"))
        val result = output_datas[0];
        var maxAt = 0
        for (i in 0 until result.size) {
            maxAt = if (result.get(i) > result.get(maxAt)) i else maxAt
        }
        val map = hashMapOf<String, Float>();
        for (i in 0 until result.size) {
            val label = labelList!![i]
            val value = result[i]
            map[label] = value
        }
        println("----")
        println("\n")
        println(map)
        println("Gesture is " + labelList!![maxAt] + " with acc: " + result[maxAt])
        println("\n")
        println("----")
        return labelList!![maxAt]
    }
    // method to load tflite file from device
    @Throws(Exception::class)
    private fun loadModelFile(context: Context):MappedByteBuffer {

        var fileDescriptor = context.assets.openFd(modelName)
        var inputStream = FileInputStream(fileDescriptor.getFileDescriptor())
        var fileChannel = inputStream.getChannel()
        var startOffset = fileDescriptor.getStartOffset()
        var declaredLength = fileDescriptor.getDeclaredLength()
        return fileChannel.map(FileChannel.MapMode.READ_ONLY, startOffset, declaredLength)
    }
    companion object {
        private val CHANNEL = "ondeviceML"
    }
    @Throws(IOException::class)
    private fun loadLabelList():List<String> {
        val labelList = ArrayList<String>()
        val reader = BufferedReader(InputStreamReader(getAssets().open(labelFileName)))
        val line:String
        reader.forEachLine { labelList.add(it) }
        reader.close()
        return labelList
    }
}
