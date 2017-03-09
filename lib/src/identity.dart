library rewrites.src.identity;

import 'dart:io';
import 'package:yaml/yaml.dart';

class IdentityData {

    final String cert;
    final String key;
    final password;

    IdentityData._(this.cert, this.key, this.password);

    static parse(String filename) async {
        File file = new File(filename);
        String content = file.readAsStringSync();
        YamlMap document = loadYaml(content);

        //if no flag, use non-ssl
        if (!document.containsKey('ssl')) return null;

        //else use ssl
        if (document['ssl'] is! List) throw "[ssl] field must be an list";
        if (!document['ssl'].containsKey['cert']) throw "[ssl] field must contain a [cert] field";
        if (!document['ssl'].containsKey['key']) throw "[ssl] field must contain a [key] field";
        //todo: password optional?
        if (!document['ssl'].containsKey['password']) throw "[ssl] field must contain a [password] field";

        IdentityData identity = new IdentityData._(document['ssl']['cert'].toString(), document['ssl']['key'].toString(), document['ssl']['password'].toString());
        return identity;
    }
}