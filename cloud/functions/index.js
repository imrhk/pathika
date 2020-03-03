const functions = require('firebase-functions');
const request = require('request');

const admin = require('firebase-admin');
admin.initializeApp();

const currencyList = ['AED', 'AFN', 'ALL', 'AMD', 'ANG', 'AOA', 'ARS', 'AUD', 'AWG', 'AZN', 'BAM', 'BBD', 'BDT', 'BGN', 'BHD', 'BIF', 'BND', 'BOB', 'BRL', 'BSD', 'BWP', 'BYN', 'BZD', 'CAD', 'CDF', 'CHF', 'CLP', 'CNY', 'COP', 'CRC', 'CUP', 'CVE', 'CZK', 'DJF', 'DKK', 'DOP', 'DZD', 'EGP', 'ERN', 'ETB', 'EUR', 'FJD', 'GBP', 'GEL', 'GHS', 'GIP', 'GMD', 'GNF', 'GTQ', 'GYD', 'HKD', 'HNL', 'HRK', 'HTG', 'HUF', 'IDR', 'ILS', 'INR', 'IQD', 'IRR', 'ISK', 'JMD', 'JOD', 'JPY', 'KES', 'KGS', 'KHR', 'KMF', 'KRW', 'KWD', 'KZT', 'LAK', 'LBP', 'LKR', 'LRD', 'LSL', 'LYD', 'MAD', 'MDL', 'MGA', 'MKD', 'MMK', 'MNT', 'MOP', 'MRO', 'MRU', 'MUR', 'MVR', 'MWK', 'MXN', 'MYR', 'MZN', 'NAD', 'NGN', 'NIO', 'NOK', 'NPR', 'NZD', 'OMR', 'PAB', 'PEN', 'PGK', 'PHP', 'PKR', 'PLN', 'PYG', 'QAR', 'RON', 'RSD', 'RUB', 'RWF', 'SAR', 'SBD', 'SCR', 'SDG', 'SEK', 'SGD', 'SLL', 'SOS', 'SRD', 'SSP', 'STN', 'SVC', 'SYP', 'SZL', 'THB', 'TJS', 'TMT', 'TND', 'TOP', 'TRY', 'TTD', 'TWD', 'TZS', 'UAH', 'UGX', 'USD', 'UYU', 'UZS', 'VES', 'VND', 'VUV', 'WST', 'XAF', 'XCD', 'XOF', 'XPF', 'YER', 'ZAR', 'ZMW']
exports.convertCurrency = functions.https.onRequest(async (req, res) => {
    const to = req.query.to;
    const from = req.query.from;
    if (to === undefined || from === undefined || !currencyList.includes(to.toUpperCase())
        || !currencyList.includes(from.toUpperCase())) {
        res.status(404).send();
        return;
    }
    const now = admin.firestore.Timestamp.now();
    const node = from + '_' + to;
    const ref = admin.firestore().collection('currency_conversion')
        .doc(node);

    ref.get()
        .then(doc => {
            if (!doc.exists || (doc.data().timestamp.seconds + 24 * 60 * 60) < now.seconds) {
                request('http://www.floatrates.com/daily/' + from.toLowerCase() + '.json', function (error, response, b) {
                    if (!error && response.statusCode === 200) {
                        var body = JSON.parse(b.toString());
                        var result = body[to.toLowerCase()].rate;
                        if (result !== undefined) {
                            ref.set({
                                value: result,
                                timestamp: now
                            });
                            var responseBody = {};
                            responseBody[node] = result;
                            res.status(200).send(responseBody);
                        }
                        for (var key in body) {
                            if (body.hasOwnProperty(key)) {
                                admin.firestore().collection('currency_conversion')
                                    .doc(from.toUpperCase() + '_' + key.toUpperCase())
                                    .set({
                                        value: body[key].rate,
                                        timestamp: now
                                    });
                            }
                        }
                    }
                    else {
                        res.status(404).send();
                    }
                });
            }
            else {
                var responseBody = {};
                responseBody[node] = doc.data().value;
                res.status(200).send(responseBody);
            }
            return null;
        })
        .catch(err => {
            console.log('Error getting document', err);
            res.status(404).send();
        });
});
