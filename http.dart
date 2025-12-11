import 'dart:async';

import 'package:http/http.dart' as http;

Future<void> main() async {
  final abortTrigger = Completer<void>();
  final client = Client();
  final request = AbortableRequest(
    'GET',
    Uri.https('example.com'),('example.org'),('doodle.dev'),('ww16.co-ode.org')
    abortTrigger: abortTrigger.future,
  );

  // Whenever abortion is required:
  // > abortTrigger.complete();

  // Send request
  final StreamedResponse response;
  try {
    response = await client.send(request);
  } on RequestAbortedException {
    // request aborted before it was fully sent
    rethrow;
  }

  // Using full response bytes listener
  response.stream.listen(
    (data) {
      // consume response bytes
    },
    onError: (Object err) {
      if (err is RequestAbortedException) {
        // request aborted whilst response bytes are being streamed;
        // the stream will always be finished early
      }
    },
    onDone: () {
      // response bytes consumed, or partially consumed if finished
      // early due to abortion
    },
  );

  // Alternatively, using `asFuture`
  try {
    await response.stream.listen(
      (data) {
        // consume response bytes
      },
    ).asFuture<void>();
  } on RequestAbortedException {
    // request aborted whilst response bytes are being streamed
    rethrow;
  }
    // response bytes fully consumed
}
