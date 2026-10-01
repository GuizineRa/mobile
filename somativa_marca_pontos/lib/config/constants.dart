class AppConstants {
  static const String appName = 'PontoGeo Bio';
  static const String appVersion = '1.0.0';

  // Configurações padrão de trabalho (Local padrão: Exemplo Corporativo / Escola Técnica)
  // Raio máximo estipulado no edital: 100 metros
  static const double maxAllowedDistanceMeters = 100.0;
  
  // Coordenadas padrão da sede da empresa/instituição de ensino
  // Coordenada exemplo (São Paulo / Centro de Inovação)
  static const double defaultOfficeLatitude = -23.550520;
  static const double defaultOfficeLongitude = -46.633308;
  static const String defaultOfficeName = 'Sede Central - Escritório 01';

  // Tipos de Registro de Ponto
  static const String punchTypeEntry = 'Entrada';
  static const String punchTypeLunchOut = 'Saída Almoço';
  static const String punchTypeLunchIn = 'Retorno Almoço';
  static const String punchTypeExit = 'Saída';

  // Métodos de Autenticação
  static const String authMethodBiometric = 'Reconhecimento Facial / Biometria';
  static const String authMethodCredentials = 'NIF / Senha';
}
