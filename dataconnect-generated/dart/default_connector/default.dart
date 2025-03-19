import 'package:firebase_data_connect/firebase_data_connect.dart';

class ConnectorConfig {
  final String region;
  final String environment;
  final String projectId;

  ConnectorConfig(this.region, this.environment, this.projectId);
}

enum CallerSDKType { generated, manual }

class FirebaseDataConnect {
  static FirebaseDataConnect instanceFor({
    required ConnectorConfig connectorConfig,
    required CallerSDKType sdkType,
  }) {
    // Implementation here
    return FirebaseDataConnect();
  }
}

class DefaultConnector {
  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-central1',
    'default',
    'safecrop',
  );

  DefaultConnector({required this.dataConnect});

  static DefaultConnector get instance {
    final dataConnect = FirebaseDataConnect.instanceFor(
      connectorConfig: connectorConfig,
      sdkType: CallerSDKType.generated,
    );
    return DefaultConnector(dataConnect: dataConnect);
  }

  FirebaseDataConnect dataConnect;
}