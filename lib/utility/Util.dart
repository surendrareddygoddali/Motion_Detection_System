class Util {
  static double quartile(List<double> values, double lowerPercent) {
    if ((values == null) || (values.length == 0)) {
      //throw new IllegalArgumentException("The data array either is null or does not contain any data.");
    }
    List<double> v = new List<double>.filled(values.length, 0, growable: true);
    //System.arraycopy(values, 0, v, 0, values.length);
    v = values.sublist(0, values.length);
    v.sort();
    int n = ((v.length * lowerPercent) ~/ 100).round();
    return v[n];
  }

  static double calculateMedian(List<double> data) {
    //clone list
    List<double> mList = List.empty();
    mList.addAll(data);

    //sort list
    mList.sort((a, b) => a.compareTo(b));

    double median;

    int middle = mList.length ~/ 2;
    if (mList.length % 2 == 1) {
      median = mList[middle];
    } else {
      median = ((mList[middle - 1] + mList[middle]) / 2.0);
    }

    return median;
  }
}
