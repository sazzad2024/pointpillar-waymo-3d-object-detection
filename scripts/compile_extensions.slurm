#!/bin/bash
#SBATCH --job-name=compile_cuda
#SBATCH --nodes=1
#SBATCH --time=01:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#SBATCH --partition=batch
#SBATCH --output=compile_%j.out
#SBATCH --error=compile_%j.err

# Load modules
module load foss/2022a
module load CUDA/11.7.0

# Initialize conda
source /project/dsi/apps/easybuild/software/Anaconda3/2023.03-1/etc/profile.d/conda.sh
conda activate /project/yzhang/alam/waymo_research1

# Set CUDA_HOME
export CUDA_HOME=/project/dsi/apps/easybuild/software/CUDA/11.7.0
export PATH=$CUDA_HOME/bin:$PATH

# Navigate to OpenPCDet
cd /project/yzhang/alam/waymo-env/waymo-od/research1/code/OpenPCDet

echo "=== Compiling OpenPCDet CUDA Extensions ==="
echo "CUDA_HOME: $CUDA_HOME"
echo "GPU available: $(nvidia-smi --query-gpu=name --format=csv,noheader,nounits | head -1)"

# Compile CUDA extensions
python setup.py build_ext --inplace

echo "=== Testing compiled extensions ==="
python -c "
try:
    from pcdet.ops.roiaware_pool3d import roiaware_pool3d_utils
    print('✅ roiaware_pool3d_cuda: SUCCESS')
except ImportError as e:
    print('❌ roiaware_pool3d_cuda: FAILED -', e)

try:
    from pcdet.ops.iou3d_nms import iou3d_nms_utils
    print('✅ iou3d_nms_cuda: SUCCESS')
except ImportError as e:
    print('❌ iou3d_nms_cuda: FAILED -', e)

try:
    from pcdet.ops.pointnet2.pointnet2_batch import pointnet2_utils
    print('✅ pointnet2_cuda: SUCCESS')
except ImportError as e:
    print('❌ pointnet2_cuda: FAILED -', e)
"

echo "=== Compilation Complete ==="
