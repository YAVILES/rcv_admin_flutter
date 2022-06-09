class PolicyService {
  static String url = '/core/policy';

  // Estatus
  static int get outstanding => 0;
  static int get pendingApproval => 1;
  static int get passed => 2;
  static int get expired => 3;
  static int get rejected => 4;
}
