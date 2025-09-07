# Setup Guide

This guide will help you set up the PointPillar Waymo 3D Object Detection project on your HPC cluster.

## Prerequisites

- HPC cluster with SLURM workload manager
- CUDA-capable GPUs (4+ recommended for training)
- Python 3.8+
- Access to Waymo Open Dataset

## Step 1: Fork OpenPCDet

1. Go to [OpenPCDet](https://github.com/open-mmlab/OpenPCDet)
2. Click "Fork" to create your own copy
3. Clone your fork:
   ```bash
   git clone https://github.com/sazzad2024/OpenPCDet.git
   cd OpenPCDet
   ```

## Step 2: Clone This Repository

```bash
git clone https://github.com/sazzad2024/pointpillar-waymo-3d-object-detection.git
cd pointpillar-waymo-3d-object-detection
```

## Step 3: Set Up Environment

### Create Conda Environment
```bash
conda create --prefix /path/to/your/waymo_env python=3.8
conda activate /path/to/your/waymo_env
```

### Install Dependencies
```bash
pip install -r requirements.txt
```

## Step 4: Download Waymo Dataset

1. Register at [Waymo Open Dataset](https://waymo.com/open)
2. Download training and validation data
3. Extract to your desired location

## Step 5: Configure Paths

Update the following files with your actual paths:

### SLURM Scripts
Edit these files in the `scripts/` directory:
- `process_waymo_data.slurm`
- `train_pointpillar_waymo_4gpu.slurm`
- `compile_extensions.slurm`

Replace these placeholders:
- `/path/to/conda` → Your conda installation path
- `/path/to/OpenPCDet` → Your OpenPCDet installation path
- `/path/to/cuda` → Your CUDA installation path

### Configuration Files
Update `configs/waymo_dataset.yaml`:
```yaml
DATA_PATH: /path/to/your/OpenPCDet/data/waymo
```

## Step 6: Prepare Data

1. Create the data directory structure:
   ```bash
   mkdir -p /path/to/OpenPCDet/data/waymo/{raw_data,ImageSets}
   ```

2. Place your Waymo .tfrecord files in `raw_data/`

3. Create ImageSets files:
   ```bash
   # Create train.txt
   ls /path/to/OpenPCDet/data/waymo/raw_data/training_*.tfrecord > /path/to/OpenPCDet/data/waymo/ImageSets/train.txt
   
   # Create val.txt
   ls /path/to/OpenPCDet/data/waymo/raw_data/validation_*.tfrecord > /path/to/OpenPCDet/data/waymo/ImageSets/val.txt
   ```

## Step 7: Compile CUDA Extensions

```bash
sbatch scripts/compile_extensions.slurm
```

## Step 8: Process Data

```bash
sbatch scripts/process_waymo_data.slurm
```

## Step 9: Train Model

```bash
sbatch scripts/train_pointpillar_waymo_4gpu.slurm
```

## Monitoring Jobs

```bash
# Check job status
squeue -u $USER

# View job output
tail -f waymo_process_*.out
tail -f train_4gpu_*.out
```

## Troubleshooting

### Common Issues

1. **CUDA_HOME not set**: Update the CUDA path in `compile_extensions.slurm`
2. **Module not found**: Check available modules with `module avail`
3. **Memory issues**: Increase `--mem` in SLURM scripts
4. **Path errors**: Ensure all paths are absolute and correct

### Getting Help

- **Simple Explanation**: Read [README-SIMPLE.md](README-SIMPLE.md) for non-technical overview
- **Technical Details**: Check [Medium blog post](docs/medium_blog.md) for comprehensive analysis
- **Easy Understanding**: Read [Simple blog post](docs/medium_blog_simple.md) for beginner-friendly explanation
- **GitHub Issues**: Open an issue for specific technical problems
- **Contact**: [A K M Sazzadul Alam](https://github.com/sazzad2024) (MS in Cybersecurity, University of Houston, Texas)

## Expected Results

After successful training, you should see:
- **Vehicle Detection**: ~70% mAP
- **Pedestrian Detection**: ~67% mAP
- **Cyclist Detection**: ~60% mAP

Training typically takes 12-18 hours on 4 GPUs.
