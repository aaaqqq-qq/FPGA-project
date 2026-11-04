# 赛题二匿名源码提交包

板卡：Ti60F225I3-V4；硬件基线100MHz；显示设计1280×720/60Hz。
本包对应当前东方Project、基础一/二/三及高阶Alpha/Color Key/压力测试工程。

## 目录与入口
- `release/projects/touhou_LAB/src/`：RISC-V游戏、BitBlt驱动、实验、层次绘制、交互和测量代码。
- `release/projects/touhou_LAB/hw/game/rtl/`：BitBlt、批绘、运动、DDR仲裁、FIFO和HDMI显示RTL。
- `release/projects/touhou_LAB/hw/game/par/ddr_demo_ti60/ddr_demo_ti60.xml`：Efinity工程入口；同目录含引脚/时序/IP配置与SoC生成源码、初始化数据。
- `release/projects/touhou_LAB/sw/`：构建实际使用的BSP、通用异常处理和驱动依赖。未使用的网络示例不纳入工程。
- `release/projects/touhou_LAB/assets/`：生成素材与对应源素材。
- `workbench/`：赛题二工作台Python源码与测试。
- `release/`：完整Flash生成、加载器、身份验证与编程工具源码。
- `tests`、`sim`、`scripts`：已有测试、仿真与构建脚本。

## 环境与运行
1. 安装Efinity 2026.1及匹配的RISC-V工具链；工具、许可证与Python依赖不随源码包分发。
2. 固件：进入`release/projects/touhou_LAB`，执行`python scripts/build_firmware.py --toolchain-bin <工具链bin目录>`。
3. 硬件：用Efinity打开上述XML；工程采用相对源码路径。首次构建由Efinity生成工作目录；本次封包不重新综合或布线。
4. 上位机：`python -m pip install -r workbench/requirements.txt`，再执行`python workbench/bootstrap.py`，或双击`START_WORKBENCH.cmd`。环境变量`FPGA_CONTROL_RUNTIME`可指定本机依赖目录。
5. 固件主机测试入口：`python scripts/verify_all.py --host-cc <宿主C编译器> --toolchain-bin <RISC-V工具链bin>`。
6. 已冻结的完整Flash备份、设备会话和旧镜像未纳入源码提交。Flash工具仍保留身份、完整镜像、读回和硬件证据门控；重新构建并核对对应发布数据后再使用，不能把历史镜像当成匿名副本的新构建结果。

## 功能与实测范围
包含Fill/Copy、数据搬运、CPU/FPGA对照、双缓冲、Alpha、颜色键、东方互动、多尺寸弹幕和负载测量实现。
既有本次录像对应：4Boss/0普通敌人/8×8敌弹15000颗、6Boss/12普通敌人/32×32敌弹5000颗，两组分别600帧短测接近60FPS；这不是十分钟长测或绝对上限。
当前已知实板问题：部分非对齐Copy与图片复制校验失败；静态Alpha64/128/255分别出现10/8/6个全屏比较错误。封包保持真实源码和测试语义，未修改这些逻辑或将失败改为通过。
其他docs包含开发历史；本文件与`VERIFICATION_SUMMARY.json`说明本次匿名源码包的核验范围。

## 匿名化与排除项
不含参赛者姓名、学号、学校、聊天标识、QQ/微信/Steam账号、USB设备实例号、个人用户目录、个人运行个人运行日志、截图、录像、个人配置、IDE缓存、Git历史和旧备份。
个人路径已改为相对路径、环境变量或中性示例；原工程未修改。素材已去除EXIF/XMP/文本作者等元数据，像素内容保留。
依法保留所用第三方代码的版权与许可证声明。这些声明属于上游依赖，不是参赛者身份信息。
文件时间统一；压缩包不保存本机绝对路径、NTFS所有者或个人归档注释。

## 本次封包复查状态
匿名副本的RISC-V固件已在用户要求停止测试之前完成一次构建：PASS，RAM使用1032944字节。
初轮上位机499项测试存在3项旧文案断言失败、8项外部归档/固定测试输入缺失、1项跳过；随后只整理了便携路径和固定输入，按用户要求未继续测试，不能称全套测试已通过。
`workbench/tests/fixtures`中的回包是固定的主机合成测试输入，不含真实用户串口会话；SoC IPM配置作为工程输入保留，未执行其序列化内容。
本包是源码提交，未附带可直接冒用的旧Flash镜像或个人设备备份；不影响原电脑工程与现有板卡内容。
