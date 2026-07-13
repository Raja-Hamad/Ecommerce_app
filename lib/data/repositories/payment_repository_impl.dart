import '../../domain/entities/payment_intent.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/remote/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final _remote = PaymentRemoteDataSource();

  @override
  Future<PaymentIntentResult> createPaymentIntent(String orderId) => _remote.createPaymentIntent(orderId);
}
