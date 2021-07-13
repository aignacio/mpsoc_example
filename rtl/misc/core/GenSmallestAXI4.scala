package vexriscv.demo

import vexriscv.plugin._
import vexriscv.{plugin, VexRiscv, VexRiscvConfig}
import spinal.core._
import spinal.lib._
import vexriscv.ip.{DataCacheConfig, InstructionCacheConfig}
import spinal.lib.com.jtag.{Jtag, JtagTapInstructionCtrl}
import vexriscv.{VexRiscv, VexRiscvConfig, plugin}

/////////////////////////////////////////////////////////////////////////////////

object GenSmallestAXI4{
  def main(args: Array[String]) {
    val report = SpinalConfig(mode = if(args.contains("--vhdl")) VHDL else Verilog).generate{

      //CPU configuration
      val cpuConfig = VexRiscvConfig(
        plugins = List(
          new IBusSimplePlugin(
            resetVector = 0x80000000l,
            cmdForkOnSecondStage = false,
            cmdForkPersistence = true,
            prediction = NONE,
            catchAccessFault = false,
            compressedGen = false
          ),
          new DBusSimplePlugin(
            catchAddressMisaligned = false,
            catchAccessFault = false
          ),
          //new CsrPlugin(CsrPluginConfig.smallest),
          new CsrPlugin(
            config = CsrPluginConfig(
              catchIllegalAccess = false,
              mvendorid      = null,
              marchid        = null,
              mimpid         = null,
              mhartid        = null,
              misaExtensionsInit = 66,
              misaAccess     = CsrAccess.NONE,
              mtvecAccess    = CsrAccess.READ_WRITE,
              mtvecInit      = 0x00000020l,
              mepcAccess     = CsrAccess.READ_WRITE,
              mscratchGen    = false,
              mcauseAccess   = CsrAccess.READ_ONLY,
              mbadaddrAccess = CsrAccess.READ_ONLY,
              mcycleAccess   = CsrAccess.NONE,
              minstretAccess = CsrAccess.NONE,
              ecallGen       = false,
              wfiGenAsWait         = false,
              ucycleAccess   = CsrAccess.NONE,
              uinstretAccess = CsrAccess.NONE
            )
          ),

          new DecoderSimplePlugin(
            catchIllegalInstruction = false
          ),
          new RegFilePlugin(
            regFileReadyKind = plugin.SYNC,
            zeroBoot = false
          ),
          new IntAluPlugin,
          new SrcPlugin(
            separatedAddSub = false,
            executeInsertion = false
          ),
          new LightShifterPlugin,
          new HazardSimplePlugin(
            bypassExecute           = false,
            bypassMemory            = false,
            bypassWriteBack         = false,
            bypassWriteBackBuffer   = false,
            pessimisticUseSrc       = false,
            pessimisticWriteRegFile = false,
            pessimisticAddressMatch = false
          ),
          //new DebugPlugin(ClockDomain.current.clone(reset = Bool().setName("debugReset"))),
          new BranchPlugin(
            earlyBranch = false,
            catchAddressMisaligned = false
          ),
          new YamlPlugin("cpu0.yaml")
        )
      )

      //CPU instanciation
      val cpu = new VexRiscv(cpuConfig)

      //CPU modifications to be an AhbLite3 one
      cpu.rework {
        for (plugin <- cpuConfig.plugins) plugin match {
          case plugin: IBusSimplePlugin => {
            plugin.iBus.setAsDirectionLess() //Unset IO properties of iBus
            master(plugin.iBus.toAxi4ReadOnly()).setName("iBusAxi")
          }
          case plugin: DBusSimplePlugin => {
            plugin.dBus.setAsDirectionLess()
            master(plugin.dBus.toAxi4()).setName("dBusAxi")
          }
          case plugin: DebugPlugin if args.contains("--jtag")=> plugin.debugClockDomain {
            plugin.io.bus.setAsDirectionLess()
            val jtag = slave(new Jtag()).setName("jtag")
            jtag <> plugin.io.bus.fromJtag()
          }
          case _ =>
        }
      }
      cpu
    }
  }
}

