import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationCenter {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "ecommerce-app-1b4de",
      "private_key_id": "ba8f7d5bd61b4b49e4f7d784008cdf916b6a4959",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC47WsabZquFyWv\nznB+OwIchMFkajga7OOnz5/tmd/+l3IxyapyNrlukVVxNAINXY+P+g1s1HUzwcn3\nPyW/jykV0UsLR9BChKi3HnnBg0d81/6Ygxr78/3WocsreoY/3kpB54IOgD0MDnAq\nPtHGHLMFbSV/JXXWOPaAQ/asb3nWghiHJ+Zh6hR4zPiwT71iPL33mcjEN9NQ5vS2\nSOkNHn/pRsk5arp0Gf390NthTV3vBYX7qg27DD6sag8IASA83FcU9C2ewd+yO9wY\n3myRn8DnAJ8WGd5cX9VO8ouA9tEOdZnFSQL1VzKFIEAVzggJqZSmKD6v3rM6OWme\nHWFffhxNAgMBAAECggEAHVI9r2rOAgj3B4VYxlcGWm29OTXzT+ecIB02SybhAn3S\nVC0Y2rOtGqguDz0zDxn025wG+WjFbY+uPYb0bgdduREekDsSfR2KH8DUBtgRI20e\n9+Efy++voZK1Q19Rvno5NXJm53QzWcBHThd4TOx7gSKBdcPDh5QwF33PNJ+XRqjE\niZIbyAiCvl6By75Tku8461kYiE1N5oa3UhW54d4Gvfa/cQrio7FoE0X5EH8Yp0+U\nfUxR8AmqPtBqYz88ZLYTojURiuuCKvbBFZ/uSJrBux/56sT3tMqGrsbZeNexvFrT\nEdfkdlRYv45e34lufFZyZ/osUAFnelf47pxn0IsVqQKBgQDan/Sac8iMBn0q4K8Q\n23QI/5RUYfDe6PRMLDIf9EAsYrO2v7Zpdk0O1W+pIYxfKFGVYc8k42rnLDwVQbYb\noWkePVhtCjO8I8qIIrKSJHH0NZaKm9GZN1acLmgkVwHSO63U3Jd9MHjkY34xQR71\nPfD4sCW107NISOBhK5JAuq08iQKBgQDYirTnmJyiANgMxlfMdGLHUi1B2G4I8DHt\ne3j0gPCXXIiBb3p9rexG7PTIbOVGPEqc8ifXoZ6DlNU/+jLCog2lH42eB0c3LHEw\n+A/OqXAWS9v1mkG0hjnWRf4uMCrZF4nK8M/d3+YefM7wxVcj8r1/6JGmpZhjzGBZ\nawokDQ9YpQKBgD2Vg1SiuuJezZFve0EXYGdMf18Ju80+99ohNPl1V0Jph1A6TssE\nbQ55pxuQfLctZ1XaGHy+pxV5i289dGvyGudOxoLotcwQlPOmOoEaTRNKqR5gaDlt\nsjMKi4F5FOVAtGXawb2dEuDa+egr/Ol+Skvzapv+h2kcRkB5ApjDPRtpAoGAJETv\nUg9ExPnBNjqOgCdKWDpSbEH1BDg/FJjmxIVIRwHvt0ZVzPExrxuHUH601FPK54jD\n1aEzbLSkF0gv8lu0T2D+lmZ/riUafGpAM4w7wvBH0lZZBQSqcVJd5ZyZwKzpnn1B\nQ9d5sseS3c8f7lx9EwyAQNphsO2Ngcyk8S7i0CUCgYEAlrEfv6RvMFHjRLOlLHsq\nUqIeUsmI2JDwCMdw5WJUWpdbTYgBfZqde0UcMOX/TRFek7WH0Qzd5iMJjUyALCGz\nccQ/mCqKu8bBFd6BsOneGoApVePHq1IgoC0a+8EB5NJ3AvULLzBAJIZ4tGzs0BnN\n8aOBQIYZkwhLNfS1D4/MeJ8=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-fbsvc@ecommerce-app-1b4de.iam.gserviceaccount.com",
      "client_id": "104325724315868566514",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40ecommerce-app-1b4de.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );

    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendMessageNotificationToClient(
    String notificationBody,
    String notificationTitle,
    String deviceToken,
    String productImage,
    String screen,
    // String jobId,
  ) async {
    final String serverKey = await getAccessToken();

    var notificationData = {
      'message': {
        'token': deviceToken, // single token here
        'notification': {
          'title': notificationTitle,
          'body': notificationBody,
          'image': productImage,
        },
        'data': {
          'image': productImage,
          // 'jobId': jobId,
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "screen": screen,
        },
      },
    };

    var response = await http.post(
      Uri.parse(
        'https://fcm.googleapis.com/v1/projects/job-finder-7544e/messages:send',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(notificationData),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) print('✅ Notification sent to $deviceToken');
    } else {
      if (kDebugMode) {
        print('❌ Failed for $deviceToken: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    }
  }

  static submitMessageNotification(
    String deviceToken,
    String notificationTitle,
    String notificationBody,
    String productImage,
    String screen,
    // String messageId,
  ) async {
    try {
      if (kDebugMode) {
        print("Device Token of the user is $deviceToken");
        print("Notification Title of the user is $notificationTitle");
        print("Notification Body of the user is $notificationBody");
      }
      if (notificationTitle.isNotEmpty && notificationBody.isNotEmpty) {
        await sendMessageNotificationToClient(
          notificationBody,
          notificationTitle,
          deviceToken,
          productImage,
          screen,
          // messageId,
        );
      } else {
        if (kDebugMode) {
          print("Please fill in all fields.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error while generating the notification ${e.toString()}");
      }
    }
  }
}
