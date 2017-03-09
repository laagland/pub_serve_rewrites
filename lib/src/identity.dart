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
        if (!document['ssl'][0].containsKey('cert')) throw "[ssl] field must contain a [cert] field";
        if (!document['ssl'][0].containsKey('key')) throw "[ssl] field must contain a [key] field";
        if (!document['ssl'][0].containsKey('password')) throw "[ssl] field must contain a [password] field";

        //read password from file
        File password_file = new File(document['ssl'][0]['password'].toString());
        String password = password_file.readAsStringSync();

        IdentityData identity = new IdentityData._(document['ssl'][0]['cert'].toString(), document['ssl'][0]['key'].toString(), password);
        return identity;
    }
}