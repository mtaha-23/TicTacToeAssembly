# TicTacToe-Assembly
- Tic-Tac-Toe game implemented in assembly (8088)  You need a 8088 emulator to run this game.
- It is a 2 player game. Player 1 will place 'X' mark and Player 2 will place 'O' mark.
- At Start both player enter their names
- You can quit the game in between using ESC

# How to Compile and Run a File in DOSBox
Follow these steps to compile and run your assembly file using DOSBox.
## Prerequisites
- Download and install [DOSBox](https://www.dosbox.com/download.php?main=1).
- Download or clone this repository.
## Steps
1. **Mount the Directory in DOSBox:**<br>
   Open DOSBox and mount the directory where your file is stored. Replace `(directory_name)` with the actual directory path:
   ```
   mount c c:\(directory_name)
2. **Switch to the Mounted Drive:**
   ```
   c:
3. **Compile the File:**<br>
   Use NASM to compile the assembly file. Replace filename.asm with the actual file name:
   ```
   nasm filename.asm -o obj.exe
5. **Run the Compiled File:**
    ```
    obj
# Game Screenshots
#### - Menu <br>
![Screenshot 2024-01-03 212332](https://github.com/mtaha-23/TicTacToe-Assembly/assets/132524394/8ad2e4ca-ec08-40af-bd45-40b391482a37)

#### - Instructions <br>
![Screenshot 2024-01-03 212340](https://github.com/mtaha-23/TicTacToe-Assembly/assets/132524394/83b8d3b7-028f-437d-92db-99ab8da33cc5)

#### - Entering Player Names<br>
![Screenshot 2024-01-03 212355](https://github.com/mtaha-23/TicTacToe-Assembly/assets/132524394/c6635615-265c-4590-bc2e-3d97c7e36747)

#### - Game Won <br>
![Screenshot 2024-01-03 214222](https://github.com/mtaha-23/TicTacToe-Assembly/assets/132524394/5bc03913-6b4b-4cb4-b0e0-51b1cdc6e75d)

#### - Game Tied <br>
![Screenshot 2024-01-03 212559](https://github.com/mtaha-23/TicTacToe-Assembly/assets/132524394/7b03ac45-2b5f-488b-890c-476dc679cd08)

#### - Game Exit <br>
![Screenshot 2024-01-03 212647](https://github.com/mtaha-23/TicTacToe-Assembly/assets/132524394/f2f719b3-4a98-464e-a390-dc86e0f767be)
