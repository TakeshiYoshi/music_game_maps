# frozen_string_literal: true

module GameMachineDecorator
  def count_info_exist?
    # countが99の場合は台数不明を表す
    count != 99
  end
end
