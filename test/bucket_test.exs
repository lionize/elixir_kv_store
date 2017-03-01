defmodule BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    {:ok, bucket: bucket}
  end

  test "stores values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "keys can be deleted", %{bucket: bucket} do
    KV.Bucket.put(bucket, "oranges", 10)
    assert KV.Bucket.get(bucket, "oranges") == 10

    KV.Bucket.delete(bucket, "oranges")
    assert KV.Bucket.get(bucket, "oranges") == nil
  end
end
