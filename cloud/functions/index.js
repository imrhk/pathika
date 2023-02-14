const functions = require("firebase-functions");
const axios = require("axios");

const admin = require("firebase-admin");
const firestore = require("firebase-admin/firestore");

admin.initializeApp();

const currencyList = [
  "AED",
  "AFN",
  "ALL",
  "AMD",
  "ANG",
  "AOA",
  "ARS",
  "AUD",
  "AWG",
  "AZN",
  "BAM",
  "BBD",
  "BDT",
  "BGN",
  "BHD",
  "BIF",
  "BND",
  "BOB",
  "BRL",
  "BSD",
  "BWP",
  "BYN",
  "BZD",
  "CAD",
  "CDF",
  "CHF",
  "CLP",
  "CNY",
  "COP",
  "CRC",
  "CUP",
  "CVE",
  "CZK",
  "DJF",
  "DKK",
  "DOP",
  "DZD",
  "EGP",
  "ERN",
  "ETB",
  "EUR",
  "FJD",
  "GBP",
  "GEL",
  "GHS",
  "GIP",
  "GMD",
  "GNF",
  "GTQ",
  "GYD",
  "HKD",
  "HNL",
  "HRK",
  "HTG",
  "HUF",
  "IDR",
  "ILS",
  "INR",
  "IQD",
  "IRR",
  "ISK",
  "JMD",
  "JOD",
  "JPY",
  "KES",
  "KGS",
  "KHR",
  "KMF",
  "KRW",
  "KWD",
  "KZT",
  "LAK",
  "LBP",
  "LKR",
  "LRD",
  "LSL",
  "LYD",
  "MAD",
  "MDL",
  "MGA",
  "MKD",
  "MMK",
  "MNT",
  "MOP",
  "MRO",
  "MRU",
  "MUR",
  "MVR",
  "MWK",
  "MXN",
  "MYR",
  "MZN",
  "NAD",
  "NGN",
  "NIO",
  "NOK",
  "NPR",
  "NZD",
  "OMR",
  "PAB",
  "PEN",
  "PGK",
  "PHP",
  "PKR",
  "PLN",
  "PYG",
  "QAR",
  "RON",
  "RSD",
  "RUB",
  "RWF",
  "SAR",
  "SBD",
  "SCR",
  "SDG",
  "SEK",
  "SGD",
  "SLL",
  "SOS",
  "SRD",
  "SSP",
  "STN",
  "SVC",
  "SYP",
  "SZL",
  "THB",
  "TJS",
  "TMT",
  "TND",
  "TOP",
  "TRY",
  "TTD",
  "TWD",
  "TZS",
  "UAH",
  "UGX",
  "USD",
  "UYU",
  "UZS",
  "VES",
  "VND",
  "VUV",
  "WST",
  "XAF",
  "XCD",
  "XOF",
  "XPF",
  "YER",
  "ZAR",
  "ZMW",
];

exports.convertCurrency = functions.https.onRequest(async (req, res) => {
  const to = req.query.to;
  const from = req.query.from;
  // console.log("to " + to + ", from =" + from);
  if (
    to === undefined ||
    from === undefined ||
    !currencyList.includes(to.toUpperCase()) ||
    !currencyList.includes(from.toUpperCase())
  ) {
    res.status(404).send();
    return;
  }
  const node = from + "_" + to;

  if (from === to) {
    const responseBody = {};
    responseBody[node] = 1;
    res.status(200).send(responseBody);
    return;
  }

  const now = firestore.Timestamp.now();
  const ref = admin.firestore().collection("currency_conversion").doc(node);
  try {
    const doc = await ref.get();
    if (
      !doc.exists ||
      doc.get("timestamp").seconds + 24 * 60 * 60 < now.seconds
    ) {
      // console.log("getting fresh data");
      try {
        // console.log(
        //   "http://www.floatrates.com/daily/" +
        //     from.toString().toLowerCase() +
        //     ".json"
        // );
        const response = await axios.get(
          "http://www.floatrates.com/daily/" +
            from.toString().toLowerCase() +
            ".json"
        );

        if (response.status === 200) {
          const body = response.data;
          // console.log(body);
          //          const body = JSON.parse(b);
          const result = body[to.toString().toLowerCase()].rate;
          // console.log("result" + result);
          if (result !== undefined) {
            ref.set({
              value: result,
              timestamp: now,
            });
            const responseBody = {};
            responseBody[node] = result;

            res.status(200).send(responseBody);
          }
          for (const key in body) {
            if (Object.prototype.hasOwnProperty.call(body, key)) {
              admin
                .firestore()
                .collection("currency_conversion")
                .doc(from.toString().toUpperCase() + "_" + key.toUpperCase())
                .set({
                  value: body[key].rate,
                  timestamp: now,
                });
            }
          }
        }
      } catch (e) {
        console.log("error while getting fresh data", e);

        res.status(404).send();
        return;
      }
    } else {
      console.log("data exists returning ", doc.data());

      const responseBody = {};
      responseBody[node] = doc.data().value;

      res.status(200).send(responseBody);
      return;
    }
    return;
  } catch (err) {
    console.log("Error getting document", err);
    res.status(404).send();
    return;
  }
});
