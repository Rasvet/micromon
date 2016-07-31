var http = require("http");
var url = require("url");
var qs = require("querystring");
//var fs = require('fs');
var mysql = require('mysql');
var dateformat = require('dateformat');

var winston = require('winston');
winston.add(winston.transports.File, { timestamp: true, filename: 'logs.log' });
winston.remove(winston.transports.Console);

var connection = mysql.createConnection({
                     host: 'localhost',
                     user: 'micromon_user',
                     password: 'Z123456z',
                     database: 'micromon'
                 });
connection.connect();


http.createServer(
 function (request, response) {
     if (request.method == 'POST') {
         var body = '';
         request.on('data', function (data) {
             body += data;

             // Too much POST data, kill the connection!
             if (body.length > 1e6)
                 req.connection.destroy();
         });


         request.on('end', function () {
            var obj;
		    var RemIP;

             try {
			    RemIP = request.connection.remoteAddress
			
			        console.log(RemIP);
			        winston.log('info', RemIP);
			
			

                 obj = JSON.parse(body);
			        console.log(obj);

                 var strProperties = '{"60":"' + RemIP + '","61":"' + obj.OS_Name + '","62":"' + obj.Computer_Description + '","63":"' + obj.Firewall + '","64":"' + obj.Auto_Update + '","65":"' + obj.Anti_Virus + '","66":"' + obj.Anti_Spyware + '","67":"' + obj.Internet_Settings + '","68":"' + obj.User_Account_Control + '","69":"' + obj.WSC_Service + '","70":"' + obj.Report_DateTime + '","71":"' + obj.Anti_Virus_Name + '","72":"' + obj.Anti_Virus_Definiton_Status + '","73":"' + obj.Anti_Virus_Protection_Status + '","74":"' + obj.Install_OS_Date + '"}';


                 var strQuery = "INSERT INTO ost_list_items ( list_id, value, extra, properties ) VALUES ( '5','" + obj.Computer_Name + "." + obj.Domain_Name + "','" + obj.Computer_Name + "','" + strProperties + "' ) ON DUPLICATE KEY UPDATE properties = '" + strProperties + "'";


                 connection.query(strQuery, function (err, result) {
                    console.log(err);
			        winston.log('error', err);
                    console.log(result);
			        winston.log('info', result);
			        console.log(strQuery);
                 });



                



             } catch (err) {

                    winston.log('error', err);
             }
             
             response.writeHead(200, { "Content-Type": "text/plain" });
             // Отправляем данные и завершаем ответ.
             //response.write('{"Here is your data": "OK"}');
             response.end();
         });




     };


 }).listen(8383);