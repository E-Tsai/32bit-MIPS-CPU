# 32bit-MIPS-CPU
*** 
###### MIPS CPU implemented in Verilog

## 实现
### 26条指令
* <b>add、addi & addu</b>   
&emsp;&emsp;&emsp;<img src=".\pics\3.jpg" height = 190/>  
*  
&emsp;&emsp;&emsp;<img src=".\pics\4.jpg" height = 190/>
* <b>sub</b>  
&emsp;&emsp;&emsp;<img src=".\pics\11.jpg" height = 90/> 
* <b>subu</b>   
&emsp;&emsp;&emsp; <img src=".\pics\12.jpg" height = 110/>
* <b>and & andi</b>   
 &emsp;&emsp; <img src=".\pics\5.jpg" height = 200/>
* <b>or</b> & ori    
&emsp;&emsp;&emsp;&emsp;<img src=".\pics\6.jpg" height = 220/>
* <b>nor</b>  
&emsp;&emsp;&emsp;&emsp;<img src=".\pics\7.jpg" height = 90/>
* <b>xor</b>  
&emsp;&emsp;&emsp;<img src=".\pics\8.jpg" height = 110/> 
* <b>bgtz</b> & bgtqz   
&emsp;&emsp;&emsp; <img src=".\pics\9.jpg" height = 230/>
* <b>bne</b>  
&emsp;&emsp;&emsp; <img src=".\pics\10.jpg" height = 130/>
* <b>j</b>  & jal  
&emsp;&emsp;&emsp; <img src=".\pics\13.jpg" height = 250/>
* <b>jr</b>   
&emsp;&emsp;&emsp;<img src=".\pics\14.jpg" height = 110/>
* <b>lw </b>   
&emsp;&emsp;&emsp;&emsp; <img src=".\pics\15.jpg" height = 110/>
* <b>sw</b>   
&emsp;&emsp;&emsp;&emsp;<img src=".\pics\16.jpg" height = 110/>  
<b>slv</b>  
&emsp;&emsp;&emsp;&emsp;<img src=".\pics\17.jpg" height = 110/>  
**等......**

31&emsp;&emsp;&emsp;&emsp;&emsp;26 25 &emsp;&emsp;&emsp;  21 20 &emsp;&emsp;&emsp;16  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;10&emsp;&emsp;&emsp;&emsp;6&emsp;&emsp;4&emsp;&emsp;&emsp;&emsp; 0
|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|&emsp;|
## 结构处理
1. 流水线的“依赖”及其处理：  
数据相关：  
编译技术：插入nop  
&emsp;&emsp;&emsp;&emsp;&emsp;forwarding技术
2. 分支预测： 动态预测    
当连续错误两次，认为预测失败，清洗流水线。  
<img src=".\pics\19.jpg" />  
3. 寄存器结构  
<img src=".\pics\18.jpg" />  
4. 控制信号  
<img src=".\pics\20.jpg" />  




测试代码：  
<code>
 .data
result: .word 0 : 20

      .text
      la $t0, result
      xor $t1, $t1, $t1
      xor $t2, $t2, $t2
      xor $t3, $t3, $t3
      xor $t4, $t4, $t4
      addi $t1, $t1, 1
      addi $t2, $t2, 2
      addi $t3, $t3, -1

      #test lw              0
      lw    $t4, 0($t0)
      addi  $t0, $t0, 4

      #test add addi        0
      add   $t5, $t1, $t3
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test addu            3
      add   $t5, $t1, $t2
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test sub             2
      sub   $t5, $t1, $t3
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test subu            1
      subu  $t5, $t2, $t1
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test and             1
      and   $t5, $t1, $t3
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test andi            16
      andi  $t5, $t3, 16
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test or              3
      or    $t5, $t1, $t2
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test nor             0
      nor   $t5, $t3, $t1
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test ori
      ori 	$t5, $t2, 4
      sw $t5, 0($t0)
      addi  $t0, $t0, 4
      #test xori
      xori 	$5, $2, 4
      sw $5, 0($t0)
      addi  $t0, $t0, 4

 

     xor $t5, $t5, $t5
     addi $t5, $t5, 1
     
     #test sll
     sll $t5, $t5, 1
     sw    $t5, 0($t0)
     addi  $t0, $t0, 4
     
     #test srl
     srl $t5, $t5, 1
     sw    $t5, 0($t0)
     addi  $t0, $t0, 4
     
     #test sllv
     sllv $t5, $t5, $t2
     sw    $t5, 0($t0)
     addi  $t0, $t0, 4
     
     #test srlv
     srlv $t5, $t5, $t2
     sw    $t5, 0($t0)
     addi  $t0, $t0, 4
    

     #test bltz bgez beq blez

     #test xor             -2
      xor   $t5, $t3, $t1
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4
      #test bgtz j          1
LABLE:
      addi  $t5, $t5, 1
      bgtz  $t5, FINISH
      j     LABLE
FINISH:
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4

      #test bnz              0
      bne   $t5, $t1, NE     #[t5] = 1
      xor   $t5, $t5, $t5
NE:
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4



      #test jr                8
      la    $t6, TJR
      xor   $t5, $t5, $t5
      jr    $t6
      addi  $t5, $t5, 16
TJR:
      addi  $t5, $t5, 8
      sw    $t5, 0($t0)
      addi  $t0, $t0, 4


      #test forword * 2       2
      la    $t6, result
      lw    $t1, 0($t6)       # $t1 = [$t0] = 0
      add   $t1, $t2, $t3
      add   $t3, $t1, $t1
      sw    $t3, 0($t0)
</code>


