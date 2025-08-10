# トグルスイッチ
# 一番右のスイッチを a に、その隣のスイッチを b に接続
set_property PACKAGE_PIN V17 [get_ports {a}]
set_property IOSTANDARD LVCMOS33 [get_ports {a}]
set_property PACKAGE_PIN V16 [get_ports {b}]
set_property IOSTANDARD LVCMOS33 [get_ports {b}]
# LED
# 一番左の LED を sum に、その隣の LED を carry に接続
set_property PACKAGE_PIN U16 [get_ports {sum}]
set_property IOSTANDARD LVCMOS33 [get_ports {sum}]
set_property PACKAGE_PIN E19 [get_ports {carry}]
set_property IOSTANDARD LVCMOS33 [get_ports {carry}]
