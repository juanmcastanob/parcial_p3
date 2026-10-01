defmodule Util do
  @moduledoc """
  Módulo de utilidades para manejo de entrada/salida y formatos.
  """

  def leer(mensaje) do
    IO.gets(mensaje)
    |> String.trim()
  end

  def imprimir_mensaje(mensaje) do
    IO.puts(mensaje)
  end

  def formatear_dinero(valor) do
    # Convierte a float y formatea a 2 decimales sin notación científica
    :erlang.float_to_binary(valor * 1.0, decimals: 2)
  end
end
