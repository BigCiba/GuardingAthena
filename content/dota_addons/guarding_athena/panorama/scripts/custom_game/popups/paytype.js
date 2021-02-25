const tCNPaytype = ["1000", "2000", "3000"];
const tAnyCommonPaytype1 = [
    "3000",
];
const tAnyCommonPaytype2 = [
    "trustpay",
    "cherrycredits",
    "qiwi",
    "yamoney",
    "webmoney",
    "yamoneyac",
    "boacompra",
];
class PayHelper {
    static TabelCount(t) {
        let count = 0;
        if (t)
            for (const k in t)
                count++;
        return count;
    }
    static GetTabelKeys(t, v) {
        const res = [];
        if (t && v)
            for (const k in t)
                if (t[k] == v)
                    res.push(k);
        return res;
    }
    static InsertNotRepat(t, t2, v2) {
        if (t && t2)
            for (const k in t2) {
                const v = v2 && v2(k, t2[k]) || t2[k];
                if (t.indexOf(v) < 0)
                    t.push(v);
            }
        return t;
    }
}
function GetPaytypes() {
    const language = $.Language().toLowerCase();
    const tPayCov = LAN2COV[language];
    const tUsePaytypes = [];
    const i2 = () => {
        if (PayHelper.TabelCount(tPayCov) > 0) {
            for (const k in tPayCov) {
                const cov = tPayCov[k];
                PayHelper.InsertNotRepat(tUsePaytypes, PayHelper.GetTabelKeys(PID2COV, cov));
            }
        }
    };
    if (language == "schinese") {
        PayHelper.InsertNotRepat(tUsePaytypes, tCNPaytype);
        PayHelper.InsertNotRepat(tUsePaytypes, tAnyCommonPaytype1);
        PayHelper.InsertNotRepat(tUsePaytypes, tAnyCommonPaytype2);
        PayHelper.InsertNotRepat(tUsePaytypes, PID2COV, k => k);
    }
    else if (language == "russian") {
        i2();
        PayHelper.InsertNotRepat(tUsePaytypes, tAnyCommonPaytype1);
        PayHelper.InsertNotRepat(tUsePaytypes, tAnyCommonPaytype2);
        PayHelper.InsertNotRepat(tUsePaytypes, PID2COV, k => k);
        PayHelper.InsertNotRepat(tUsePaytypes, tCNPaytype);
    }
    else {
        PayHelper.InsertNotRepat(tUsePaytypes, tAnyCommonPaytype1);
        PayHelper.InsertNotRepat(tUsePaytypes, tAnyCommonPaytype2);
        i2();
        PayHelper.InsertNotRepat(tUsePaytypes, PID2COV, k => k);
        PayHelper.InsertNotRepat(tUsePaytypes, tCNPaytype);
    }
    return tUsePaytypes;
}
function GetPayTypeImg(paytype) {
    return "file://{resources}/images/payment_icon/" + paytype + ".png";
}
//# sourceMappingURL=paytype.js.map