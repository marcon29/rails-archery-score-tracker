class ConnectFormatAndScoringConcerns < ActiveRecord::Migration[6.0]
  def change
    add_reference :rounds, :round_format, index: true
    add_reference :rsets, :set_end_format, index: true
  end
end
