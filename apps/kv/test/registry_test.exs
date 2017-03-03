defmodule RegistryTest do
  use ExUnit.Case, async: true
  alias KV.Registry
  alias KV.Bucket

  setup context do
    {:ok, _} = Registry.start_link(context.test)
    {:ok, registry: context.test}
  end

  test "spawns buckets", %{registry: registry} do
    assert Registry.lookup(registry, "shopping") == :error

    Registry.create(registry, "shopping")
    assert {:ok, bucket} = Registry.lookup(registry, "shopping")

    Bucket.put(bucket, "milk", 1)
    assert Bucket.get(bucket, "milk") == 1
  end

  test "removes buckets on exit", %{registry: registry} do
    Registry.create(registry, "shopping")
    {:ok, bucket} = Registry.lookup(registry, "shopping")
    Agent.stop(bucket)

    # Do a call to ensure registry processes the DOWN message
    _ = Registry.create(registry, "bogus")
    assert Registry.lookup(registry, "shopping") == :error
  end

  test "removes bucket on crash", %{registry: registry} do
    Registry.create(registry, "shopping")
    {:ok, bucket} = Registry.lookup(registry, "shopping")

    Process.exit(bucket, :shutdown)

    ref = Process.monitor(bucket)
    assert_receive {:DOWN, ^ref, _, _, _}

    _ = Registry.create(registry, "bogus")
    assert Registry.lookup(registry, "shopping") == :error
  end
end
