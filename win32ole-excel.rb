#!/usr/bin/env ruby -w 
require 'WIN32OLE'

excel = WIN32OLE::new('excel.application')
puts ".... WIN32OLE: #{excel.class}: #{excel}"
#excel.visible =true
wb = excel.workbooks.add
puts 'add workbook...'
sheet = wb.sheets(1)
sheet.cells(1,1).value = "abc|123.3"
sheet.Cells(2,1).value = "cdb|789.44"
sheet.Cells(3,1).value = "2019-04-05|lakbae"
puts 'add data'
sheet.range("A:A").select
sheet.range("A:A").TextToColumns(:Destination => sheet.range("E1"), :DataType => 1, :TextQualifier => 1, 
						  :ConsecutiveDelimiter => false, 
						  :Tab=> true, :Semicolon => false, :Comma => false, :Space => false, :Other => true, :OtherChar => '|',
 						  :FieldInfo=>[[1,1],[2,2]], :TrailingMinusNumbers => true)						  
#						  :FieldInfo=>'Array(Array(1, 1), Array(2, 2))', :TrailingMinusNumbers=>true)
#
puts 'ok.....'
wb.saveas('.\lsqypj.xls', :FileFormat => -4143) # 56 for xls, 51 for xlsx, more info https://docs.microsoft.com/zh-cn/office/vba/api/excel.xlfileformat
puts 'xls gen....'
