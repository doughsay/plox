defmodule Plox.Axis do
  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Access

      @impl Access
      def fetch(axis, value) do
        {:ok, Plox.Axis.Proto.to_graph(axis, value)}
      end

      @impl Access
      def pop(_axis, _key) do
        raise "Not implemented"
      end

      @impl Access
      def get_and_update(_axis, _key, _function) do
        raise "Not implemented"
      end
    end
  end
end
