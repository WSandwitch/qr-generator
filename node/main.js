const { QRCodeStyling } = require("qr-code-styling/lib/qr-code-styling.common.js");
//const nodeCanvas = require("canvas");
const { JSDOM } = require("jsdom");
const fs = require("fs");

var util= require('util');
var encoder = new util.TextEncoder('utf-8');
const yargs = require("yargs");

const args = yargs
 .usage("Usage: -n <name>")
 .option("d", { alias: "data", type: "string", demandOption: true })
 .option("c", { alias: "color", type: "string", demandOption: true })
 .option("b", { alias: "bcolor", type: "string", demandOption: true })
 .option("i", { alias: "image", type: "string", demandOption: false })
 .option("l", { alias: "level", type: "string", demandOption: true })
 .option("t", { alias: "dtype", type: "string", demandOption: true })
 .option("s", { alias: "qstype", type: "string", demandOption: true })
 .option("q", { alias: "qdtype", type: "string", demandOption: true })
 .argv;

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
        margin: 1
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

/*
// For svg type with the inner-image saved as a blob
// (inner-image will render in more places but file will be larger)
const qrCodeSvgWithBlobImage = new QRCodeStyling({
    jsdom: JSDOM, // this is required
    nodeCanvas, // this is required
    type: "svg",
    ...options,
    imageOptions: {
        saveAsBlob: true,
        crossOrigin: "anonymous",
        margin: 20
    }
});

qrCodeSvgWithBlobImage.getRawData("svg").then((buffer) => {
  fs.writeFileSync("test_blob.svg", buffer);
});
*/

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
  console.log(buffer.toString('base64'));
//  fs.writeFileSync("test.svg", buffer);
});
