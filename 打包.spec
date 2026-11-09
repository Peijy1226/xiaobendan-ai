# -*- coding: utf-8 -*-
"""小笨蛋 PyInstaller 打包配置

要点：
  · onedir（文件夹版）—— 启动快，机房电脑不用装 Python
  · 不带控制台（windowed）—— 双击就出界面
  · 收集 rapidocr 自带的 3 个 OCR 模型 + onnxruntime 的 dll
  · Tcl/Tk 数据目录由 PyInstaller 自带 hook 处理；这里再显式兜一层
  · 不把素材/模型/壁纸打进包 —— 它们和 exe 同级放，方便用户自己改
"""
import os
import sys

# 项目根目录（这个 spec 文件所在目录）
ROOT = os.path.dirname(os.path.abspath(SPEC))
SRC = ROOT

# 用 D:/PyThon 的解释器时，tcl 数据在 <python>/tcl
PYDIR = os.path.dirname(sys.executable)

block_cipher = None

# ---- 需要一起打进去的数据文件 ----
datas = []

# 1) rapidocr 的模型（不 collect-all 的话 onnx 模型不会被带上）
try:
    import rapidocr_onnxruntime
    _rr = os.path.dirname(rapidocr_onnxruntime.__file__)
    for sub in ("models", "config.yaml"):
        p = os.path.join(_rr, sub)
        if os.path.isdir(p):
            datas.append((p, os.path.join("rapidocr_onnxruntime", sub)))
        elif os.path.isfile(p):
            datas.append((p, "rapidocr_onnxruntime"))
    # 字体（部分版本有）
    for sub in ("resources", "fonts"):
        p = os.path.join(_rr, sub)
        if os.path.isdir(p):
            datas.append((p, os.path.join("rapidocr_onnxruntime", sub)))
    # 三个子模块自己还各带一份 config.yaml（运行时要读）
    for sub in ("ch_ppocr_v3_det", "ch_ppocr_v3_rec", "ch_ppocr_v2_cls"):
        p = os.path.join(_rr, sub)
        if os.path.isdir(p):
            datas.append((p, os.path.join("rapidocr_onnxruntime", sub)))
except Exception as e:
    print("!! rapidocr 数据收集失败:", e)

# 2) Tcl/Tk 脚本目录（PyInstaller 6 一般会自动处理，这里显式补，双保险）
for d in ("tcl", "tk"):
    p = os.path.join(PYDIR, d)
    if os.path.isdir(p):
        datas.append((p, d))

# 3) edge-tts 的 certifi 证书（打包后 SSL 校验要它）
try:
    import certifi
    datas.append((certifi.where(), "certifi"))
except Exception:
    pass

hidden = [
    "tkinter", "tkinter.font", "tkinter.filedialog", "tkinter.messagebox",
    "PIL", "PIL.Image", "PIL.ImageTk", "PIL.ImageDraw", "PIL.ImageFilter",
    "PIL.ImageEnhance", "PIL.ImageChops", "PIL.ImageStat",
    "numpy", "cv2", "onnxruntime", "rapidocr_onnxruntime",
    "rapidocr_onnxruntime.ch_ppocr_v3_det",
    "rapidocr_onnxruntime.ch_ppocr_v3_rec",
    "rapidocr_onnxruntime.ch_ppocr_v2_cls",
    "pyclipper", "shapely", "yaml",
    "edge_tts", "aiohttp", "certifi",
    "urllib.request", "urllib.error", "urllib.parse",
    "json", "queue", "asyncio", "ctypes", "ctypes.wintypes",
    "sqlite3", "encodings.idna",
]

excludes = [
    "matplotlib", "scipy", "pandas", "IPython", "jupyter", "notebook",
    "test", "tests", "unittest", "pydoc_data", "lib2to3",
    "PyQt5", "PyQt6", "PySide2", "PySide6", "wx",
    "tornado", "zmq", "sphinx", "setuptools", "pip",
]

a = Analysis(
    [os.path.join(SRC, "小笨蛋.py")],
    pathex=[SRC],
    binaries=[],
    datas=datas,
    hiddenimports=hidden,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=excludes,
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

# 去掉一批用不到的大文件，压体积（Tk 的 demo、numpy 的测试等）
def _drop(entry):
    name = entry[0].replace("\\", "/").lower()
    bad = (
        "/tk9.0/demos/", "/tk8.6/demos/",
        "/numpy/tests/", "/numpy/f2py/tests/",
        "/cv2/data/",
        "/shapely/tests/",
        "/rapidocr_onnxruntime/resources/fonts/",
    )
    if any(b in name for b in bad):
        return False
    if name.endswith((".pyc",)) and "/test" in name:
        return False
    return True

a.datas = [d for d in a.datas if _drop(d)]
a.binaries = [b for b in a.binaries if _drop(b)]

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name="小笨蛋",
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon=os.path.join(ROOT, "图标", "app_icon.ico"),
)

coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=False,
    upx_exclude=[],
    name="小笨蛋",
)
