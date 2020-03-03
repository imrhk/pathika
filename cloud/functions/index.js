const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp();

const currencyList = ['DZD','NAD','QAR','EGP','BGN','BMD','PAB','BOB','DKK','BWP','LBP','TZS','VND','AOA','KHR','MYR','KYD','LYD','UAH','JOD','AWG','SAR','XAG','HKD','CHF','GIP','BYR','CDF','BYN','MRO','HRK','DJF','THB','XAF','BND','VUV','UYU','NIO','LAK','GHS','SYP','MAD','MZN','PHP','ZAR','NPR','ZWL','NGN','CRC','AED','GBP','MWK','LKR','PKR','HUF','RON','LSL','MNT','AMD','UGX','XDR','JMD','GEL','SHP','AFN','SBD','KPW','TRY','BDT','YER','GGP','HTG','SLL','MGA','ANG','LRD','RWF','NOK','MOP','INR','MXN','CZK','TJS','BTC','BTN','COP','TMT','MUR','IDR','HNL','ETB','FJD','ISK','PEN','BZD','ILS','DOP','AZN','MDL','BSD','SEK','ZMK','MVR','AUD','SRD','CUP','CLF','BBD','KMF','KRW','GMD','VEF','GTQ','CUC','CLP','ZMW','EUR','ALL','XCD','KZT','XPF','RUB','TTD','OMR','BRL','MMK','PLN','PYG','KES','SVC','MKD','TWD','TOP','JEP','GNF','WST','IQD','ERN','BAM','SCR','CAD','CVE','KWD','BIF','PGK','SOS','SGD','UZS','STD','IRR','CNY','XOF','TND','GYD','NZD','FKP','LVL','USD','KGS','ARS','SZL','IMP','RSD','BHD','JPY','SDG'];
exports.convertCurrency = functions.https.onRequest(async (req, res) => {
    const to = req.query.to;
    const from = req.query.from;
    if(to === undefined || from === undefined || !currencyList.includes(to.toUpperCase()) || !currencyList.includes(from.toUpperCase())){

    }
 });
