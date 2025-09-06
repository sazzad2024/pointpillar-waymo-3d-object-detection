# PointPillar Waymo 3D Object Detection

This project trains a PointPillar 3D object detector on the Waymo Open Dataset using OpenPCDet framework on HPC clusters.

## 🚀 Results

| Object Class | LEVEL_1 (Easy) | LEVEL_2 (Hard) | Industry Benchmark |
|--------------|-----------------|----------------|--------------------|
| **Vehicle**  | **70.72%**     | **63.05%**     | 65-70%            |
| **Pedestrian** | **67.69%**   | **59.76%**     | 60-65%            |
| **Cyclist**  | **60.53%**     | **57.60%**     | 55-60%            |

## ✨ Key Features

- **360° LiDAR Coverage**: 150m × 150m detection range
- **Multi-class Detection**: Vehicles, pedestrians, cyclists
- **HPC Optimized**: SLURM batch scripts for cluster training
- **State-of-the-art Performance**: Exceeds industry benchmarks

## 🏗️ Architecture

PointPillar converts sparse LiDAR point clouds into dense 2D representations:
1. **Organize points** into vertical columns (pillars)
2. **Apply PointNet** to extract features from each pillar
3. **Use 2D CNN backbone** for efficient processing
4. **Generate 3D bounding boxes** with high accuracy

## 📁 Project Structure

```
pointpillar-waymo-3d-object-detection/
├── configs/                    # Configuration files
│   ├── waymo_dataset.yaml
│   └── pointpillar_1x.yaml
├── scripts/                    # SLURM batch scripts
│   ├── process_waymo_data.slurm
│   ├── train_pointpillar_waymo_4gpu.slurm
│   └── compile_extensions.slurm
├── results/                    # Training results
│   ├── training_logs/
│   └── evaluation_metrics/
├── docs/                       # Documentation
│   └── medium_blog.md
├── requirements.txt
├── LICENSE
└── README.md
```

## 🚀 Quick Start

### Prerequisites
- HPC cluster with SLURM
- CUDA-capable GPUs
- Python 3.8+
- Waymo Open Dataset

### Setup
1. **Fork OpenPCDet**: [Your-Username/OpenPCDet](https://github.com/your-username/OpenPCDet)
2. **Clone this repository**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/pointpillar-waymo-3d-object-detection.git
   cd pointpillar-waymo-3d-object-detection
   ```
3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```
4. **Download Waymo dataset** (separately)
5. **Run SLURM scripts**:
   ```bash
   sbatch scripts/process_waymo_data.slurm
   sbatch scripts/train_pointpillar_waymo_4gpu.slurm
   ```

## 📚 Documentation

- **Complete Guide**: [Medium Blog Post](docs/medium_blog.md)
- **Training Pipeline**: Step-by-step data processing and training
- **Results Analysis**: Performance metrics and insights

## 🔗 Based on OpenPCDet

- **Original framework**: [OpenPCDet](https://github.com/open-mmlab/OpenPCDet)
- **My fork with modifications**: [Your-Username/OpenPCDet](https://github.com/your-username/OpenPCDet)
- **License**: Apache 2.0

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [OpenPCDet](https://github.com/open-mmlab/OpenPCDet) framework by OpenMMLab
- [Waymo Open Dataset](https://waymo.com/open) for providing the dataset
- PointPillar paper: [arXiv:1812.05784](https://arxiv.org/abs/1812.05784)

## 📞 Contact

For questions or collaboration opportunities, please open an issue or contact [Your Name].

---
**Total project timeline**: 2 weeks  
**Training time**: 18.5 hours  
**Hardware**: 4×GPU, 128GB RAM, 16 CPU cores
