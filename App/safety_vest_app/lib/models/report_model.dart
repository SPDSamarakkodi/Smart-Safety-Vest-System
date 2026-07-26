class ReportModel {


final String workerId;


final double temperatureAvg;
final double temperatureMax;
final double temperatureMin;


final double humidity;


final double gas;


final double heartRate;


final double latitude;
final double longitude;



ReportModel({

required this.workerId,

required this.temperatureAvg,
required this.temperatureMax,
required this.temperatureMin,

required this.humidity,

required this.gas,

required this.heartRate,

required this.latitude,
required this.longitude,

});


}