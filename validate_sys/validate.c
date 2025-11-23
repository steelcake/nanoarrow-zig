#include <nanoarrow/nanoarrow.h>
#include <stdio.h>
#include <stdlib.h>

void nanoarrowzig_validate(
  struct ArrowArray* const input_array,
  struct ArrowSchema* const input_schema,
  void (*validate_fail)(void)
) {
  if (!input_array || !input_schema) {
    fprintf(stderr, "Error: NULL pointer\n");
    exit(1);
  }

  ArrowErrorCode result;
  struct ArrowError error;
  struct ArrowArrayView view;

  ArrowErrorInit(&error);

  result = ArrowArrayViewInitFromSchema(&view, input_schema, &error);
  if (result != NANOARROW_OK) {
    fprintf(stderr, "ArrowArrayViewInitFromSchema failed: %s\n", ArrowErrorMessage(&error));
    validate_fail();
  }

  result = ArrowArrayViewSetArray(&view, input_array, &error);
  if (result != NANOARROW_OK) {
    fprintf(stderr, "ArrowArrayViewSetArray failed: %s\n", ArrowErrorMessage(&error));
    validate_fail();
  }

  result = ArrowArrayViewValidate(&view, NANOARROW_VALIDATION_LEVEL_FULL, &error);
  if (result != NANOARROW_OK) {
    fprintf(stderr, "ArrowArrayViewValidate failed: %s\n", ArrowErrorMessage(&error));
    validate_fail();
  }
}
