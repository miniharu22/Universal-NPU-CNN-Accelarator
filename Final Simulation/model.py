import torch
import torch.nn as nn
import torch.nn.functional as F

# ====================================================
# Define CNN Model in PyTorch
# ====================================================
class CNNModel(nn.Module):
    def __init__(self):
        super(CNNModel, self).__init__()
        # 1st Convolution + Pooling
        self.conv1 = nn.Conv2d(
            in_channels=1,
            out_channels=1,
            kernel_size=3,
            padding=1,  # 'same' padding
            bias=True
        )
        self.pool1 = nn.MaxPool2d(kernel_size=2, stride=2)

        # Zero Padding: top=2, bottom=1, left=2, right=1
        self.pad = nn.ZeroPad2d((2, 1, 2, 1))

        # 2nd Convolution + Pooling
        self.conv2 = nn.Conv2d(
            in_channels=1,
            out_channels=8,
            kernel_size=4,
            bias=True
        )
        self.pool2 = nn.MaxPool2d(kernel_size=2, stride=2)

        # Dropout layers
        self.dropout1 = nn.Dropout(p=0.25)
        self.dropout2 = nn.Dropout(p=0.5)

        # Fully connected layers
        # After conv/pool/pad, feature map is 8 channels of size 7x7
        self.fc1 = nn.Linear(8 * 7 * 7, 1000)
        self.fc2 = nn.Linear(1000, 10)

    def forward(self, x):
        # Convolution + ReLU + Pool
        x = F.relu(self.conv1(x))
        x = self.pool1(x)

        # Zero padding
        x = self.pad(x)

        # 2nd Convolution + ReLU + Pool
        x = F.relu(self.conv2(x))
        x = self.pool2(x)

        # Dropout + Flatten
        x = self.dropout1(x)
        x = torch.flatten(x, 1)

        # Fully connected + ReLU + Dropout
        x = F.relu(self.fc1(x))
        x = self.dropout2(x)

        # Final output
        x = self.fc2(x)
        # Apply softmax if needed:
        # x = F.softmax(x, dim=1)
        return x