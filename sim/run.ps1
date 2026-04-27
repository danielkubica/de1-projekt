<#
.SYNOPSIS
    PowerShell script to automate GHDL simulation (Makefile equivalent).
.USAGE
    .\build.ps1         - Runs the full simulation (all)
    .\build.ps1 view    - Opens GTKWave
    .\build.ps1 clean   - Removes build artifacts
#>

Param(
    [Parameter(Position=0)]
    [ValidateSet("all", "view", "clean")]
    [string]$Target = "all"
)

# --- Variables ---
$GHDL      = "ghdl"
$TOP       = "tb_breathing_led_top"
$BUILD_DIR = "build"

# --- Functions ---

function Run-All {
    # 1. Create directory if it doesn't exist (mkdir -p)
    if (!(Test-Path $BUILD_DIR)) {
        New-Item -ItemType Directory -Path $BUILD_DIR | Out-Null
    }

    Write-Host "--- Importing HDL files ---" -ForegroundColor Cyan
    & $GHDL -i --workdir=$BUILD_DIR ../hdl/*.vhd ../tb/*.vhd

    Write-Host "--- Elaborating Design ---" -ForegroundColor Cyan
    & $GHDL -m --workdir=$BUILD_DIR $TOP

    Write-Host "--- Running Simulation ---" -ForegroundColor Green
    & $GHDL -r --workdir=$BUILD_DIR $TOP --vcd="./$BUILD_DIR/result.vcd"
}

function Run-View {
    $VcdFile = "./$BUILD_DIR/result.vcd"
    $SaveFile = "./gtkwave-signals-templates/$TOP.sav"
    
    if (Test-Path $VcdFile) {
        Write-Host "--- Opening GTKWave ---" -ForegroundColor Yellow
        & gtkwave -g $VcdFile $SaveFile
    } else {
        Write-Error "VCD file not found. Run the build first."
    }
}

function Run-Clean {
    Write-Host "--- Cleaning Build Directory ---" -ForegroundColor Red
    if (Test-Path $BUILD_DIR) {
        Remove-Item -Recurse -Force $BUILD_DIR
    }
    & $GHDL --clean
}

# --- Execution ---
switch ($Target) {
    "all"   { Run-All }
    "view"  { Run-View }
    "clean" { Run-Clean }
}