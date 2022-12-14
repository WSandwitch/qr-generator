const { QRCodeStyling } = require("qr-code-styling/lib/qr-code-styling.common.js");
//const nodeCanvas = require("canvas");
const { JSDOM } = require("jsdom");
const fs = require("fs");

var http = require('http');
const url = require('url');

http.createServer( function(req, res){
    const args = url.parse(req.url,true).query;
// const args = parser.argv;
        console.log(args)
        const options = {
                width: 300,
                height: 300,
                data: args.data,
                image: args.image,
                qrOptions:{
                        errorCorrectionLevel: args.level
                },
                dotsOptions: {
                        color: args.color,//"#4267b2",
                        type: args.dtype
                },
                backgroundOptions: {
                        color: args.bcolor,
                },
                imageOptions: {
                        crossOrigin: "anonymous",
                        margin: 0
                },
                cornersSquareOptions: {
                        color: args.color,
                        type: args.qstype
                },
                cornersDotOptions: {
                        color: args.color,
                        type: args.qdtype
                }
        }


try{
        // For svg type
        const qrCodeSvg = new QRCodeStyling({
                jsdom: JSDOM, // this is required
                type: "svg",
                ...options,
                imageOptions: {
                        saveAsBlob: !!args.image,
                        crossOrigin: "anonymous"
                }
        });

        //console.log(qrCodeSvg.getRawData("svg"));

        qrCodeSvg.getRawData("svg").then((buffer) => {
          res.end(buffer.toString('base64'));
        //  fs.writeFileSync("test.svg", buffer);
        });
}catch(e){
        console.log(e)
         res.end("")
}
}).listen(8080)
