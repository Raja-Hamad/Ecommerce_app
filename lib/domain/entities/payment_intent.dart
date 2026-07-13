class PaymentIntentResult {
  const PaymentIntentResult({required this.clientSecret, required this.paymentIntentId});

  final String clientSecret;
  final String paymentIntentId;
}
