<#
.SYNOPSIS
    PowerShell script to automate GHDL simulation for Surfer.
.USAGE
    .\build.ps1         - Runs the full simulation (all)
    .\build.ps1 view    - Opens Surfer
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
# Changed extension to .fst
$WAVE_FILE = "./$BUILD_DIR/result.fst"

# --- Functions ---

function Run-All {
    if (!(Test-Path $BUILD_DIR)) {
        New-Item -ItemType Directory -Path $BUILD_DIR | Out-Null
    }

    Write-Host "--- Importing HDL files ---" -ForegroundColor Cyan
    & $GHDL -i --workdir=$BUILD_DIR ../hdl/*.vhd ../tb/*.vhd

    Write-Host "--- Elaborating Design ---" -ForegroundColor Cyan
    & $GHDL -m --workdir=$BUILD_DIR $TOP

    Write-Host "--- Running Simulation (Generating FST) ---" -ForegroundColor Green
    # The flag changes from --vcd to --fst
    & $GHDL -r --workdir=$BUILD_DIR $TOP "--fst=$WAVE_FILE"
}

function Run-View {
    # Define paths based on your variable $TOP
    $TemplateDir   = "./surfer-signals-templates"
    $WorkspaceFile = "$TemplateDir/$TOP.surf.ron"
    
    if (Test-Path $WAVE_FILE) {
        Write-Host "--- Opening Surfer ---" -ForegroundColor Yellow
        Write-Host "Waveform: $WAVE_FILE" -ForegroundColor Gray

        if (Test-Path $WorkspaceFile) {
            Write-Host "Template: $WorkspaceFile (Applied)" -ForegroundColor Cyan
            # Launch Surfer with the specific container state (workspace)
            & surfer $WAVE_FILE -s $WorkspaceFile
        } else {
            Write-Host "No template found at $WorkspaceFile. Opening raw waveform." -ForegroundColor DarkGray
            & surfer $WAVE_FILE
        }
    } else {
        Write-Error "Waveform file not found. Run '.\build.ps1' (all) first."
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