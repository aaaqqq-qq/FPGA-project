# 赛题二：FPGA 二维图形加速系统

## 一、作品概述

本作品基于 Ti60F225I3-V4 开发板，实现由 RISC-V 处理器控制的 FPGA 二维图形加速系统。处理器负责游戏逻辑和任务提交，FPGA 负责图形填充、复制、透明混合等绘制操作，绘制结果经 DDR 帧缓存输出至独立显示器。

系统使用 **100 MHz 硬件基线**，显示设计为 **1280×720、HDMI 60 Hz**。电脑端“赛题二工作台”提供实验参数设置、游戏控制、图片导入和运行数据展示。东方 Project 弹幕场景用于展示硬件绘制效果及高负载交互。

本仓库提供硬件工程、板端程序、上位机和构建工具源码。评审可先阅读下方功能对照与实测结果，再按需打开工程或复现。

## 二、下载与解压：请先完成这一步

**仓库地址：** https://github.com/aaaqqq-qq/FPGA-project

1. 点击仓库页面绿色 **Code** 按钮，选择 **Download ZIP**。公开仓库支持免登录下载。
2. 解压下载的 `FPGA-project-main.zip`。
3. 打开解压得到的 `FPGA-project-main` 文件夹，将里面的 **`release.zip` 解压到当前文件夹**。
4. `release.zip` 已同时包含 `release/` 与 `workbench/`。另附的 `workbench.zip` 是同一套上位机文件的独立副本；可以保留，也可解压到同一位置。
5. 确认以下目录结构。上位机启动入口与两个源码文件夹应位于同一级。

```text
FPGA-project-main/
├─ README.md
├─ START_WORKBENCH.cmd
├─ START_WORKBENCH.sh
├─ FILE_MANIFEST.json
├─ VERIFICATION_SUMMARY.json
├─ ANONYMITY_REVIEW.json
├─ THIRD_PARTY_NOTICES.txt
├─ release/
│  ├─ projects/touhou_LAB/
│  │  ├─ src/                 板端程序与图形驱动
│  │  ├─ hw/game/             FPGA 硬件工程
│  │  ├─ sw/                  BSP 与驱动依赖
│  │  ├─ assets/              图形素材
│  │  ├─ scripts/             固件构建与检查入口
│  │  ├─ tests/               主机测试
│  │  └─ sim/                 仿真相关文件
│  └─ …                       加载器及完整 Flash 发布工具
└─ workbench/
   ├─ bootstrap.py            上位机启动入口
   ├─ requirements.txt        Python 依赖
   └─ …                       界面、通信、实验与测试源码
```

如果仅解压最外层 ZIP，就直接点击启动，上位机源码文件夹尚未展开，会出现找不到文件的情况。解压后应直接找到 `workbench/bootstrap.py` 和 `release/projects/touhou_LAB/src/game.c`，避免多套一层同名文件夹。

## 三、赛题功能与代码阅读入口

下表说明实现内容与源码位置；各项验证范围见第五节。

| 赛题模块 | 本作品实现内容 | 建议阅读位置 |
|---|---|---|
| 基础一：图形操作与显示 | 矩形填充、图形复制、测试图、图片导入与位置调整、HDMI 输出 | `src/lab.c`、`src/bitblt.c`、`hw/game/rtl/` |
| 基础二：数据搬运 | DDR 访问、突发传输与 FIFO；分散小块和合并区域的搬运对照 | `src/labx.c`、`src/bitblt.c`、`hw/game/rtl/` |
| 基础三：驱动与双缓冲 | C 驱动、任务提交、前后帧缓存切换、CPU 与 FPGA 绘制性能对照 | `src/bitblt.c`、`src/game.c`、`src/scene.c`、`src/labx.c` |
| 高阶一：Alpha 透明混合 | 前景与背景按透明度混色、半透明弹幕叠加演示 | `src/adv.c`、`src/adv_model.c`、`hw/game/rtl/` |
| 高阶二：颜色键去背 | 跳过指定背景色；颜色键与透明混合的组合路径 | `src/adv.c`、`src/bitblt.c`、`hw/game/rtl/` |
| 高阶三：互动与高负载应用 | 东方弹幕、角色移动、暂停与重开、多 Boss/普通敌人、多尺寸弹幕测量 | `src/game.c`、`src/battle.c`、`src/player.c`、`src/enemies.c`、`src/scene.c` |
| 电脑控制与实验界面 | 图形预览、参数配置、串口控制、下载进度、测量与日志展示 | `workbench/` |

表中 `src/` 和 `hw/` 均以 `release/projects/touhou_LAB/` 为起点。电脑预览用于参数与原理观察；开发板真实绘制画面由独立显示器输出。

## 四、打开工程与运行方法

### 4.1 所需环境

- FPGA 工具：Efinity 2026.1，以及相应器件支持和许可证。
- 板端编译：支持 RV32 的 RISC-V GCC 工具链；默认工具前缀为 `riscv-none-elf-`。
- 上位机：Python 3，依赖版本见 `workbench/requirements.txt`。主要界面与通信依赖为 PySide6-Essentials 6.8.3、pyserial 3.5；PyInstaller 仅用于生成 Windows 可执行程序。
- 实板操作：Ti60F225I3-V4、USB/JTAG 连接和接在 TX 输出端的独立显示器。

### 4.2 启动上位机

在解压后的仓库根目录打开终端，执行：

```sh
python -m pip install -r workbench/requirements.txt
python workbench/bootstrap.py
```

Windows 安装依赖后，也可双击根目录 `START_WORKBENCH.cmd`。命令行启动方式便于直接查看环境缺失等提示。

上位机启动后，可以浏览实验页面；实际执行图形实验、电脑操控与获取板端数据，需要连接配套固件的开发板。串口号应选择当前电脑实际识别到的板卡串口。

### 4.3 打开 FPGA 工程

使用 Efinity 打开：

```text
release/projects/touhou_LAB/hw/game/par/ddr_demo_ti60/ddr_demo_ti60.xml
```

该 XML 采用相对路径引用源码。同目录包含引脚、时序和 IP 配置、SoC 生成源码与初始化数据。综合、布局布线和生成配置文件应使用对应工具环境完成。

### 4.4 编译板端程序

在 `release/projects/touhou_LAB/` 目录执行以下命令，把示例工具链目录替换为实际安装目录：

```sh
python scripts/build_firmware.py --toolchain-bin "C:/Toolchains/riscv/bin"
```

已有固件验证入口为：

```sh
python scripts/verify_all.py --host-cc "C:/Toolchains/host/bin/gcc.exe" --toolchain-bin "C:/Toolchains/riscv/bin"
```

上述路径仅为中性示例。宿主 C 编译器与 RISC-V 编译器分别用于主机验证和板端构建。

### 4.5 实板与 Flash 发布

`release/` 中保留加载器、完整 Flash 镜像生成、身份核对和编程工具源码。源码提交包提供重新构建所需的项目输入；工具安装包、许可证、预编译 EXE、既有完整 Flash 镜像及设备备份由各自运行环境管理。

重新构建得到的固件与硬件应配套使用，并按发布工具要求补齐相应身份、镜像和硬件验证材料后进行编程。文件下载、固件编译与整机上板是三个不同的操作环节。

## 五、已展示结果与验证范围

### 5.1 录像对应的实测数据

| 测试 | 配置 | 结果 |
|---|---|---|
| 数据搬运对照 | 960×480，分散小块与合并区域 | 28.749 ms → 7.331 ms，耗时比约 3.92× |
| CPU / FPGA 绘制对照 | 相同图形任务 | CPU 约 3.600 ms/帧，FPGA 约 0.318 ms/帧，绘制加速约 11.34× |
| 高负载配置 A | 8×8 敌弹 15,000 颗，4 Boss、0 普通敌人 | 600 帧，约 10 秒，约 60 FPS |
| 高负载配置 B | 32×32 敌弹 5,000 颗，6 Boss、12 普通敌人 | 600 帧，约 10 秒，约 60 FPS |
| 颜色键展示用例 | 指定颜色跳过及前后效果对照 | 对应全屏读回检查像素错误为 0 |

60 Hz 为显示输出规格，FPS 为相应测试中的实际更新速率；3.92× 与 11.34× 均是对应任务的耗时比。两档弹幕结果属于上述配置的短测，时长约 10 秒。录像与技术文档中的测试条件应与各项成绩配套阅读。

### 5.2 当前验证状态

- 匿名源码副本已完成一次 RISC-V 固件构建，记录为通过，RAM 使用量 1,032,944 字节。
- 部分非对齐 Copy 与图片复制用例仍存在像素校验错误；静态 Alpha 64、128、255 的已有用例分别记录 10、8、6 个全屏比较错误。
- 双缓冲代码已实现；本次演示材料中的专项验收证据仍待补充。
- 初轮上位机共运行 499 项测试，记录 3 项失败、8 项错误、1 项跳过；后续整理了便携路径和固定输入，尚未完成全量复测。
- 本次源码封包未重新综合、布局布线或进行新的板端复测。核验状态详见根目录 `VERIFICATION_SUMMARY.json`。

`docs/` 中保留开发过程材料。关于本次提交的范围与状态，请优先阅读本说明和 `VERIFICATION_SUMMARY.json`。
