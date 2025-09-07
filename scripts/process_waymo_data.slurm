#!/bin/bash
#SBATCH --job-name=waymo_process
#SBATCH --nodes=1
#SBATCH --time=08:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --gres=gpu:1
#SBATCH --partition=batch
#SBATCH --output=waymo_process_%j.out
#SBATCH --error=waymo_process_%j.err

# Load modules (adjust for your cluster)
module load foss/2022a
module load CUDA/11.7.0

# Initialize conda (adjust path for your cluster)
source /path/to/conda/etc/profile.d/conda.sh
conda activate waymo_env

# Set PYTHONPATH (adjust path to your OpenPCDet installation)
export PYTHONPATH=/path/to/OpenPCDet:$PYTHONPATH

# Navigate to OpenPCDet directory
cd /path/to/OpenPCDet

# Fix DATA_PATH in config (ensure it points to correct location)
sed -i 's|DATA_PATH: .*|DATA_PATH: /path/to/OpenPCDet/data/waymo|' tools/cfgs/dataset_configs/waymo_dataset.yaml

echo "=== Final Data Processing with GPU ==="
echo "Training files: $(wc -l < data/waymo/ImageSets/train.txt)"
echo "Validation files: $(wc -l < data/waymo/ImageSets/val.txt)"

# Run the complete data processing (this will create the groundtruth database)
python -m pcdet.datasets.waymo.waymo_dataset --func create_waymo_infos --cfg_file tools/cfgs/dataset_configs/waymo_dataset.yaml

echo "=== Processing Complete! ==="
echo "Checking generated files:"
ls -la data/waymo/waymo_processed_data_v0_5_0_infos_*.pkl
ls -la data/waymo/waymo_processed_data_v0_5_0_waymo_dbinfos_train_sampled_1.pkl 2>/dev/null || echo "GT database not created yet"
