var http = require("http");
var url = require( "url" );
var qs = require( "querystring" );
var fs = require('fs');

var winston = require('winston');
winston.add(winston.transports.File, { filename: 'logs.log' });
winston.remove(winston.transports.Console);


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
		try {
			obj = JSON.parse(body);
        	
    				
		
    
			
			var outputFilename = obj.Computer_Name +'.json';

			

        fs.open(outputFilename, "w",  0666, function(err, file_handle) {
		if (!err) {
    			fs.write(file_handle, JSON.stringify(obj), null, 'UTF-8', function(err, written) {
        			if (!err) {
            			// Всё прошло хорошо, делаем нужные действия и закрываем соединение с файлом.
            				fs.close(file_handle);
        			} else {
            			// Произошла ошибка при записи
					winston.log('error', err);
					//response.end();
       		 		}
    				});
		} else {
    		// Обработка ошибок при открытии
			winston.log('error', body + " " + err);
			//response.end();
		}
		});
		
		} catch(err) {
			
			winston.log('error', err);
		}	
				response.writeHead(200, {"Content-Type" : "text/plain"});
			// Отправляем данные и завершаем ответ.
				//response.write('{"Here is your data": "OK"}');
				response.end();	});
			
		

		
    };
	

}).listen(8383);