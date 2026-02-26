// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_remote_datasource.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(examRemoteDataSource)
const examRemoteDataSourceProvider = ExamRemoteDataSourceProvider._();

final class ExamRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ExamRemoteDataSource,
          ExamRemoteDataSource,
          ExamRemoteDataSource
        >
    with $Provider<ExamRemoteDataSource> {
  const ExamRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'examRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$examRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ExamRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ExamRemoteDataSource create(Ref ref) {
    return examRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExamRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExamRemoteDataSource>(value),
    );
  }
}

String _$examRemoteDataSourceHash() =>
    r'3080be3576efac858c448a8515cb629031ccae5c';
