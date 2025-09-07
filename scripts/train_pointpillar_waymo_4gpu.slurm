#!/bin/bash
#SBATCH --job-name=pointpillar_4gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=72:00:00
#SBATCH --mem=128G
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:4
#SBATCH --partition=batch
#SBATCH --output=train_4gpu_%j.out
#SBATCH --error=train_4gpu_%j.err

# Load modules (adjust for your cluster)
module load foss/.2022a
module load CUDA/.11.7.0

# Initialize conda (adjust path for your cluster)
source /path/to/conda/etc/profile.d/conda.sh
conda activate waymo_env

# Set PYTHONPATH (adjust path to your OpenPCDet installation)
export PYTHONPATH=/path/to/OpenPCDet:$PYTHONPATH

# Navigate to OpenPCDet directory
cd /path/to/OpenPCDet

# Fix DATA_PATH in waymo_dataset.yaml to point to correct location
sed -i 's|DATA_PATH: .*|DATA_PATH: /path/to/OpenPCDet/data/waymo|' tools/cfgs/dataset_configs/waymo_dataset.yaml

# Fix _BASE_CONFIG_ path in pointpillar_1x.yaml to use absolute path
sed -i 's|_BASE_CONFIG_: cfgs/dataset_configs/waymo_dataset.yaml|_BASE_CONFIG_: /path/to/OpenPCDet/tools/cfgs/dataset_configs/waymo_dataset.yaml|' tools/cfgs/waymo_models/pointpillar_1x.yaml

echo "=== 🚀 Starting PointPillar 4-GPU Training ==="
echo "Job ID: $SLURM_JOB_ID"
echo "Node: $SLURMD_NODENAME"
echo "GPUs: $CUDA_VISIBLE_DEVICES"
echo "Start time: $(date)"

# Verify data files exist
echo "=== 📊 Data Verification ==="
echo "Training data: $(ls -lh data/waymo/waymo_processed_data_v0_5_0_infos_train.pkl)"
echo "Validation data: $(ls -lh data/waymo/waymo_processed_data_v0_5_0_infos_val.pkl)"
echo "GT database: $(ls -lh data/waymo/waymo_processed_data_v0_5_0_waymo_dbinfos_train_sampled_1.pkl)"

# Verify CUDA extensions
echo "=== 🔧 CUDA Extensions Check ==="
python -c "
try:
    from pcdet.ops.roiaware_pool3d import roiaware_pool3d_utils
    from pcdet.ops.iou3d_nms import iou3d_nms_utils  
    from pcdet.ops.pointnet2.pointnet2_batch import pointnet2_utils
    print('✅ All CUDA extensions loaded successfully!')
except Exception as e:
    print('❌ CUDA extension error:', e)
    exit(1)
"

# Start training
echo "=== 🎯 Starting Training ==="
torchrun \
    --nproc_per_node=4 \
    --master_port=29500 \
    tools/train.py \
    --cfg_file /path/to/OpenPCDet/tools/cfgs/waymo_models/pointpillar_1x.yaml \
    --batch_size 8 \
    --epochs 30 \
    --workers 2 \
    --launcher pytorch \
    --sync_bn \
    --fix_random_seed \
    --ckpt_save_interval 5 \
    --max_ckpt_save_num 5

echo "=== ✅ Training Complete ==="
echo "End time: $(date)"
echo "Check output directory: output/waymo_models/pointpillar_1x/default/"
