// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Price _$PriceFromJson(Map<String, dynamic> json) => Price()
  ..productCode = json['product_code'] as String?
  ..productName = json['product_name'] as String?
  ..categoryTag = json['category_tag'] as String?
  ..labelsTags =
      (json['labels_tags'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..originsTags =
      (json['origins_tags'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..price = json['price'] as num
  ..priceIsDiscounted = json['price_is_discounted'] as bool?
  ..priceWithoutDiscount = json['price_without_discount'] as num?
  ..pricePer = $enumDecodeNullable(_$PricePerEnumMap, json['price_per'])
  ..currency = $enumDecode(_$CurrencyEnumMap, json['currency'])
  ..locationOSMId = (json['location_osm_id'] as num).toInt()
  ..locationOSMType =
      $enumDecode(_$LocationOSMTypeEnumMap, json['location_osm_type'])
  ..date = JsonHelper.stringTimestampToDate(json['date'])
  ..proofId = (json['proof_id'] as num?)?.toInt()
  ..id = (json['id'] as num).toInt()
  ..productId = (json['product_id'] as num?)?.toInt()
  ..locationId = (json['location_id'] as num?)?.toInt()
  ..proof = json['proof'] == null
      ? null
      : Proof.fromJson(json['proof'] as Map<String, dynamic>)
  ..location = json['location'] == null
      ? null
      : Location.fromJson(json['location'] as Map<String, dynamic>)
  ..product = json['product'] == null
      ? null
      : PriceProduct.fromJson(json['product'] as Map<String, dynamic>)
  ..receiptQuantity = (json['receipt_quantity'] as num?)?.toInt()
  ..type = $enumDecodeNullable(_$PriceTypeEnumMap, json['type'])
  ..owner = json['owner'] as String
  ..created = JsonHelper.stringTimestampToDate(json['created'])
  ..updated = JsonHelper.nullableStringTimestampToDate(json['updated']);

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'product_code': instance.productCode,
      'product_name': instance.productName,
      'category_tag': instance.categoryTag,
      'labels_tags': instance.labelsTags,
      'origins_tags': instance.originsTags,
      'price': instance.price,
      'price_is_discounted': instance.priceIsDiscounted,
      'price_without_discount': instance.priceWithoutDiscount,
      'price_per': _$PricePerEnumMap[instance.pricePer],
      'currency': _$CurrencyEnumMap[instance.currency]!,
      'location_osm_id': instance.locationOSMId,
      'location_osm_type': _$LocationOSMTypeEnumMap[instance.locationOSMType]!,
      'date': instance.date.toIso8601String(),
      'proof_id': instance.proofId,
      'id': instance.id,
      'product_id': instance.productId,
      'location_id': instance.locationId,
      'proof': instance.proof,
      'location': instance.location,
      'product': instance.product,
      'receipt_quantity': instance.receiptQuantity,
      'type': _$PriceTypeEnumMap[instance.type],
      'owner': instance.owner,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated?.toIso8601String(),
    };

const _$PricePerEnumMap = {
  PricePer.unit: 'UNIT',
  PricePer.kilogram: 'KILOGRAM',
};

const _$CurrencyEnumMap = {
  Currency.ADP: 'ADP',
  Currency.AED: 'AED',
  Currency.AFA: 'AFA',
  Currency.AFN: 'AFN',
  Currency.ALK: 'ALK',
  Currency.ALL: 'ALL',
  Currency.AMD: 'AMD',
  Currency.ANG: 'ANG',
  Currency.AOA: 'AOA',
  Currency.AOK: 'AOK',
  Currency.AON: 'AON',
  Currency.AOR: 'AOR',
  Currency.ARA: 'ARA',
  Currency.ARL: 'ARL',
  Currency.ARM: 'ARM',
  Currency.ARP: 'ARP',
  Currency.ARS: 'ARS',
  Currency.ATS: 'ATS',
  Currency.AUD: 'AUD',
  Currency.AWG: 'AWG',
  Currency.AZM: 'AZM',
  Currency.AZN: 'AZN',
  Currency.BAD: 'BAD',
  Currency.BAM: 'BAM',
  Currency.BAN: 'BAN',
  Currency.BBD: 'BBD',
  Currency.BDT: 'BDT',
  Currency.BEC: 'BEC',
  Currency.BEF: 'BEF',
  Currency.BEL: 'BEL',
  Currency.BGL: 'BGL',
  Currency.BGM: 'BGM',
  Currency.BGN: 'BGN',
  Currency.BGO: 'BGO',
  Currency.BHD: 'BHD',
  Currency.BIF: 'BIF',
  Currency.BMD: 'BMD',
  Currency.BND: 'BND',
  Currency.BOB: 'BOB',
  Currency.BOL: 'BOL',
  Currency.BOP: 'BOP',
  Currency.BOV: 'BOV',
  Currency.BRB: 'BRB',
  Currency.BRC: 'BRC',
  Currency.BRE: 'BRE',
  Currency.BRL: 'BRL',
  Currency.BRN: 'BRN',
  Currency.BRR: 'BRR',
  Currency.BRZ: 'BRZ',
  Currency.BSD: 'BSD',
  Currency.BTN: 'BTN',
  Currency.BUK: 'BUK',
  Currency.BWP: 'BWP',
  Currency.BYB: 'BYB',
  Currency.BYN: 'BYN',
  Currency.BYR: 'BYR',
  Currency.BZD: 'BZD',
  Currency.CAD: 'CAD',
  Currency.CDF: 'CDF',
  Currency.CHE: 'CHE',
  Currency.CHF: 'CHF',
  Currency.CHW: 'CHW',
  Currency.CLE: 'CLE',
  Currency.CLF: 'CLF',
  Currency.CLP: 'CLP',
  Currency.CNH: 'CNH',
  Currency.CNX: 'CNX',
  Currency.CNY: 'CNY',
  Currency.COP: 'COP',
  Currency.COU: 'COU',
  Currency.CRC: 'CRC',
  Currency.CSD: 'CSD',
  Currency.CSK: 'CSK',
  Currency.CUC: 'CUC',
  Currency.CUP: 'CUP',
  Currency.CVE: 'CVE',
  Currency.CYP: 'CYP',
  Currency.CZK: 'CZK',
  Currency.DDM: 'DDM',
  Currency.DEM: 'DEM',
  Currency.DJF: 'DJF',
  Currency.DKK: 'DKK',
  Currency.DOP: 'DOP',
  Currency.DZD: 'DZD',
  Currency.ECS: 'ECS',
  Currency.ECV: 'ECV',
  Currency.EEK: 'EEK',
  Currency.EGP: 'EGP',
  Currency.ERN: 'ERN',
  Currency.ESA: 'ESA',
  Currency.ESB: 'ESB',
  Currency.ESP: 'ESP',
  Currency.ETB: 'ETB',
  Currency.EUR: 'EUR',
  Currency.FIM: 'FIM',
  Currency.FJD: 'FJD',
  Currency.FKP: 'FKP',
  Currency.FRF: 'FRF',
  Currency.GBP: 'GBP',
  Currency.GEK: 'GEK',
  Currency.GEL: 'GEL',
  Currency.GHC: 'GHC',
  Currency.GHS: 'GHS',
  Currency.GIP: 'GIP',
  Currency.GMD: 'GMD',
  Currency.GNF: 'GNF',
  Currency.GNS: 'GNS',
  Currency.GQE: 'GQE',
  Currency.GRD: 'GRD',
  Currency.GTQ: 'GTQ',
  Currency.GWE: 'GWE',
  Currency.GWP: 'GWP',
  Currency.GYD: 'GYD',
  Currency.HKD: 'HKD',
  Currency.HNL: 'HNL',
  Currency.HRD: 'HRD',
  Currency.HRK: 'HRK',
  Currency.HTG: 'HTG',
  Currency.HUF: 'HUF',
  Currency.IDR: 'IDR',
  Currency.IEP: 'IEP',
  Currency.ILP: 'ILP',
  Currency.ILR: 'ILR',
  Currency.ILS: 'ILS',
  Currency.INR: 'INR',
  Currency.IQD: 'IQD',
  Currency.IRR: 'IRR',
  Currency.ISJ: 'ISJ',
  Currency.ISK: 'ISK',
  Currency.ITL: 'ITL',
  Currency.JMD: 'JMD',
  Currency.JOD: 'JOD',
  Currency.JPY: 'JPY',
  Currency.KES: 'KES',
  Currency.KGS: 'KGS',
  Currency.KHR: 'KHR',
  Currency.KMF: 'KMF',
  Currency.KPW: 'KPW',
  Currency.KRH: 'KRH',
  Currency.KRO: 'KRO',
  Currency.KRW: 'KRW',
  Currency.KWD: 'KWD',
  Currency.KYD: 'KYD',
  Currency.KZT: 'KZT',
  Currency.LAK: 'LAK',
  Currency.LBP: 'LBP',
  Currency.LKR: 'LKR',
  Currency.LRD: 'LRD',
  Currency.LSL: 'LSL',
  Currency.LTL: 'LTL',
  Currency.LTT: 'LTT',
  Currency.LUC: 'LUC',
  Currency.LUF: 'LUF',
  Currency.LUL: 'LUL',
  Currency.LVL: 'LVL',
  Currency.LVR: 'LVR',
  Currency.LYD: 'LYD',
  Currency.MAD: 'MAD',
  Currency.MAF: 'MAF',
  Currency.MCF: 'MCF',
  Currency.MDC: 'MDC',
  Currency.MDL: 'MDL',
  Currency.MGA: 'MGA',
  Currency.MGF: 'MGF',
  Currency.MKD: 'MKD',
  Currency.MKN: 'MKN',
  Currency.MLF: 'MLF',
  Currency.MMK: 'MMK',
  Currency.MNT: 'MNT',
  Currency.MOP: 'MOP',
  Currency.MRO: 'MRO',
  Currency.MRU: 'MRU',
  Currency.MTL: 'MTL',
  Currency.MTP: 'MTP',
  Currency.MUR: 'MUR',
  Currency.MVP: 'MVP',
  Currency.MVR: 'MVR',
  Currency.MWK: 'MWK',
  Currency.MXN: 'MXN',
  Currency.MXP: 'MXP',
  Currency.MXV: 'MXV',
  Currency.MYR: 'MYR',
  Currency.MZE: 'MZE',
  Currency.MZM: 'MZM',
  Currency.MZN: 'MZN',
  Currency.NAD: 'NAD',
  Currency.NGN: 'NGN',
  Currency.NIC: 'NIC',
  Currency.NIO: 'NIO',
  Currency.NLG: 'NLG',
  Currency.NOK: 'NOK',
  Currency.NPR: 'NPR',
  Currency.NZD: 'NZD',
  Currency.OMR: 'OMR',
  Currency.PAB: 'PAB',
  Currency.PEI: 'PEI',
  Currency.PEN: 'PEN',
  Currency.PES: 'PES',
  Currency.PGK: 'PGK',
  Currency.PHP: 'PHP',
  Currency.PKR: 'PKR',
  Currency.PLN: 'PLN',
  Currency.PLZ: 'PLZ',
  Currency.PTE: 'PTE',
  Currency.PYG: 'PYG',
  Currency.QAR: 'QAR',
  Currency.RHD: 'RHD',
  Currency.ROL: 'ROL',
  Currency.RON: 'RON',
  Currency.RSD: 'RSD',
  Currency.RUB: 'RUB',
  Currency.RUR: 'RUR',
  Currency.RWF: 'RWF',
  Currency.SAR: 'SAR',
  Currency.SBD: 'SBD',
  Currency.SCR: 'SCR',
  Currency.SDD: 'SDD',
  Currency.SDG: 'SDG',
  Currency.SDP: 'SDP',
  Currency.SEK: 'SEK',
  Currency.SGD: 'SGD',
  Currency.SHP: 'SHP',
  Currency.SIT: 'SIT',
  Currency.SKK: 'SKK',
  Currency.SLE: 'SLE',
  Currency.SLL: 'SLL',
  Currency.SOS: 'SOS',
  Currency.SRD: 'SRD',
  Currency.SRG: 'SRG',
  Currency.SSP: 'SSP',
  Currency.STD: 'STD',
  Currency.STN: 'STN',
  Currency.SUR: 'SUR',
  Currency.SVC: 'SVC',
  Currency.SYP: 'SYP',
  Currency.SZL: 'SZL',
  Currency.THB: 'THB',
  Currency.TJR: 'TJR',
  Currency.TJS: 'TJS',
  Currency.TMM: 'TMM',
  Currency.TMT: 'TMT',
  Currency.TND: 'TND',
  Currency.TOP: 'TOP',
  Currency.TPE: 'TPE',
  Currency.TRL: 'TRL',
  Currency.TRY: 'TRY',
  Currency.TTD: 'TTD',
  Currency.TWD: 'TWD',
  Currency.TZS: 'TZS',
  Currency.UAH: 'UAH',
  Currency.UAK: 'UAK',
  Currency.UGS: 'UGS',
  Currency.UGX: 'UGX',
  Currency.USD: 'USD',
  Currency.USN: 'USN',
  Currency.USS: 'USS',
  Currency.UYI: 'UYI',
  Currency.UYP: 'UYP',
  Currency.UYU: 'UYU',
  Currency.UYW: 'UYW',
  Currency.UZS: 'UZS',
  Currency.VEB: 'VEB',
  Currency.VED: 'VED',
  Currency.VEF: 'VEF',
  Currency.VES: 'VES',
  Currency.VND: 'VND',
  Currency.VNN: 'VNN',
  Currency.VUV: 'VUV',
  Currency.WST: 'WST',
  Currency.XAF: 'XAF',
  Currency.XAG: 'XAG',
  Currency.XAU: 'XAU',
  Currency.XBA: 'XBA',
  Currency.XBB: 'XBB',
  Currency.XBC: 'XBC',
  Currency.XBD: 'XBD',
  Currency.XCD: 'XCD',
  Currency.XDR: 'XDR',
  Currency.XEU: 'XEU',
  Currency.XFO: 'XFO',
  Currency.XFU: 'XFU',
  Currency.XOF: 'XOF',
  Currency.XPD: 'XPD',
  Currency.XPF: 'XPF',
  Currency.XPT: 'XPT',
  Currency.XRE: 'XRE',
  Currency.XSU: 'XSU',
  Currency.XTS: 'XTS',
  Currency.XUA: 'XUA',
  Currency.XXX: 'XXX',
  Currency.YDD: 'YDD',
  Currency.YER: 'YER',
  Currency.YUD: 'YUD',
  Currency.YUM: 'YUM',
  Currency.YUN: 'YUN',
  Currency.YUR: 'YUR',
  Currency.ZAL: 'ZAL',
  Currency.ZAR: 'ZAR',
  Currency.ZMK: 'ZMK',
  Currency.ZMW: 'ZMW',
  Currency.ZRN: 'ZRN',
  Currency.ZRZ: 'ZRZ',
  Currency.ZWD: 'ZWD',
  Currency.ZWL: 'ZWL',
  Currency.ZWR: 'ZWR',
};

const _$LocationOSMTypeEnumMap = {
  LocationOSMType.node: 'NODE',
  LocationOSMType.way: 'WAY',
  LocationOSMType.relation: 'RELATION',
};

const _$PriceTypeEnumMap = {
  PriceType.product: 'PRODUCT',
  PriceType.category: 'CATEGORY',
};
