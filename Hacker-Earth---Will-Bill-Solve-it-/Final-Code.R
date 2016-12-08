#### Code for India Hack Machine Learning Problem : Will Bill solve it? #########
###### Author : Aayush Agrawal #############

#Initializing Library
library('readr')
library('xgboost')
library('sqldf')

#setting working library
setwd('../Final/')

# Import Training Datasets
user_train <- read_csv('../train/users.csv')
submission_train <- read_csv('../train/submissions.csv')
problem_train <- read_csv('../train/problems.csv')

# Import Testing Datasets
user_test <- read_csv('../test/users.csv')
submission_test <- read_csv('../test/test.csv')
problem_test <- read_csv('../test/problems.csv')


#combining user data of test and train
user_combined <- rbind(user_train, user_test)

#making corpus of user skills 
user_combined[is.na(user_combined$skills),]$skills <- 'Missing'
user_combined$C <- NA
user_combined$Cplus <- NA
user_combined$Java <- NA
user_combined$Python <- NA
user_combined$C_hash <- NA
user_combined$PHP <- NA
user_combined$Javascript_rhino <- NA
user_combined$Text <- NA
user_combined$Javascript <- NA
user_combined$Ruby <- NA
user_combined$Javascript_node <- NA
user_combined$C_objective <- NA
user_combined$Perl <- NA
user_combined$Haskell <- NA
user_combined$Clojure <- NA
user_combined$Befunge <- NA
user_combined$Cplus_g <- NA
user_combined$Go <- NA
user_combined$Java_open <- NA
user_combined$Lisp <- NA
user_combined$Pascal <- NA
user_combined$R <- NA
user_combined$Rust <- NA
user_combined$Scala <- NA
user_combined$Whenever <- NA


Corpus <- strsplit(user_combined$skills, "|",fixed = TRUE)
for (i in 1:length(Corpus)) {
  for (j in 1:length(Corpus[i][[1]])) {
    if(Corpus[i][[1]][j] == 'C') {user_combined$C[i] <- 1}
    if(Corpus[i][[1]][j] == 'C++') {user_combined$Cplus[i] <- 1}
    if(Corpus[i][[1]][j] == 'Java') {user_combined$Java[i] <- 1}
    if(Corpus[i][[1]][j] == 'Python') {user_combined$Python[i] <- 1}
    if(Corpus[i][[1]][j] == 'C#') {user_combined$C_hash[i] <- 1}
    if(Corpus[i][[1]][j] == 'PHP') {user_combined$PHP[i] <- 1}
    if(Corpus[i][[1]][j] == 'JavaScript(Rhino)') {user_combined$Javascript_rhino[i] <- 1}
    if(Corpus[i][[1]][j] == 'Text') {user_combined$Text[i] <- 1}
    if(Corpus[i][[1]][j] == 'JavaScript') {user_combined$Javascript[i] <- 1}
    if(Corpus[i][[1]][j] == 'Ruby') {user_combined$Ruby[i] <- 1}
    if(Corpus[i][[1]][j] == 'JavaScript(Node.js)') {user_combined$Javascript_node[i] <- 1}
    if(Corpus[i][[1]][j] == 'Objective-C') {user_combined$C_objective[i] <- 1}
    if(Corpus[i][[1]][j] == 'Perl') {user_combined$Perl[i] <- 1}
    if(Corpus[i][[1]][j] == 'Haskell') {user_combined$Haskell[i] <- 1}
    if(Corpus[i][[1]][j] == 'Clojure') {user_combined$Clojure[i] <- 1}
    if(Corpus[i][[1]][j] == 'Befunge') {user_combined$Befunge[i] <- 1}
    if(Corpus[i][[1]][j] == 'C++ (g++ 4.8.1)') {user_combined$Cplus_g[i] <- 1}
    if(Corpus[i][[1]][j] == 'Go') {user_combined$Go[i] <- 1}
    if(Corpus[i][[1]][j] == 'Java (openjdk 1.7.0_09)') {user_combined$Java_open[i] <- 1}
    if(Corpus[i][[1]][j] == 'Lisp') {user_combined$Lisp[i] <- 1}
    if(Corpus[i][[1]][j] == 'Pascal') {user_combined$Pascal[i] <- 1}
    if(Corpus[i][[1]][j] == 'Python 3') {user_combined$Python[i] <- 1}
    if(Corpus[i][[1]][j] == 'R(RScript)') {user_combined$R[i] <- 1}
    if(Corpus[i][[1]][j] == 'Scala') {user_combined$Scala[i] <- 1}
    if(Corpus[i][[1]][j] == 'Rust') {user_combined$Rust[i] <- 1}
    if(Corpus[i][[1]][j] == 'Whenever') {user_combined$Whenever[i] <- 1}
  }
}

#Filling Missing Value with zeros
user_combined[is.na(user_combined)] <- 0


# Total Skills
user_combined$Skills_count <- apply(user_combined[,6:30] == 1 ,1,sum)

#Changing Formats
user_combined$user_type <- as.factor(user_combined$user_type)
user_combined$C <- as.factor(user_combined$C)
user_combined$Cplus <- as.factor(user_combined$Cplus)
user_combined$Java <- as.factor(user_combined$Java)
user_combined$Python <- as.factor(user_combined$Python)
user_combined$C_hash <- as.factor(user_combined$C_hash)
user_combined$PHP <- as.factor(user_combined$PHP)
user_combined$Javascript_rhino <- as.factor(user_combined$Javascript_rhino)
user_combined$Text <- as.factor(user_combined$Text)
user_combined$Javascript <- as.factor(user_combined$Javascript)
user_combined$Ruby <- as.factor(user_combined$Ruby)
user_combined$Javascript_node <- as.factor(user_combined$Javascript_node)
user_combined$C_objective <- as.factor(user_combined$C_objective)
user_combined$Perl <- as.factor(user_combined$Perl)
user_combined$Haskell <- as.factor(user_combined$Haskell)
user_combined$Clojure <- as.factor(user_combined$Clojure)
user_combined$Befunge <- as.factor(user_combined$Befunge)
user_combined$Cplus_g <- as.factor(user_combined$Cplus_g)
user_combined$Go <- as.factor(user_combined$Go)
user_combined$Java_open <- as.factor(user_combined$Java_open)
user_combined$Lisp <- as.factor(user_combined$Lisp)
user_combined$Pascal <- as.factor(user_combined$Pascal)
user_combined$R <- as.factor(user_combined$R)
user_combined$Rust <- as.factor(user_combined$Rust)
user_combined$Scala <- as.factor(user_combined$Scala)
user_combined$Whenever <- as.factor(user_combined$Whenever)

user_combined$Success_rate <- (user_combined$solved_count * 100) / (user_combined$attempts+user_combined$solved_count)
user_combined <- user_combined[,-2]

user_train <- user_combined[1:62530,]
user_test <- user_combined[62531:77809,]


#Working on Problem Dataset

#combining training and testing problem datasets
problem_combined <- rbind(problem_train, problem_test)
problem_combined$tag_count <- 5 - rowSums(is.na(problem_combined[,7:11]))
problem_combined[is.na(problem_combined)]   <- -999

problem_combined$Adhoc <- NA
problem_combined$Algorithms <- NA
problem_combined$Basic_programming <- NA
problem_combined$Bit_manipulation <- NA
problem_combined$DS <- NA
problem_combined$Dynamic_programming <- NA
problem_combined$Game_theory <- NA
problem_combined$Geometry <- NA
problem_combined$Graph_theory <- NA
problem_combined$HL_deco <- NA
problem_combined$Implementation <- NA
problem_combined$Map <- NA
problem_combined$Mathematics <- NA
problem_combined$Programming <- NA
problem_combined$Search_tree <- NA
problem_combined$Simulation <- NA
problem_combined$Sorting <- NA
problem_combined$Stack <- NA
problem_combined$String_algorithm <- NA


# Tag1
problem_combined[problem_combined$tag1 == 'adhoc',]$Adhoc <- 1
problem_combined[problem_combined$tag1 == 'Ad-Hoc',]$Adhoc <- 1
problem_combined[problem_combined$tag1 == 'Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Basic Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag1 == 'Basic-Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag1 == 'Bellman Ford',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'BFS',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'BFS',]$Search_tree <- 1
problem_combined[problem_combined$tag1 == 'Binary Search',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Binary Search',]$Search_tree <- 1
problem_combined[problem_combined$tag1 == 'Binary Search Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Binary Search Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag1 == 'Binary Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Binary Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag1 == 'Bipartite Graph',]$Graph_theory <- 1
problem_combined[problem_combined$tag1 == 'BIT',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag1 == 'Bit manipulation',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag1 == 'Bitmask',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag1 == 'Brute Force',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'cake-walk',]$Programming <- 1
problem_combined[problem_combined$tag1 == 'Combinatorics',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Data Structures',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Data-Structures',]$DS <- 1
problem_combined[problem_combined$tag1 == 'DFS',]$Search_tree <- 1
problem_combined[problem_combined$tag1 == 'DFS',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Dijkstra',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Disjoint Set',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Divide And Conquer',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Dynamic Programming',]$Dynamic_programming <- 1
problem_combined[problem_combined$tag1 == 'Dynamic Programming',]$Programming <- 1
problem_combined[problem_combined$tag1 == 'Fenwick Tree',]$DS <- 1
problem_combined[problem_combined$tag1 == 'FFT',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Flow',]$Programming <- 1
problem_combined[problem_combined$tag1 == 'Floyd Warshall',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Game Theory',]$Game_theory <- 1
problem_combined[problem_combined$tag1 == 'GCD',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Geometry',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Geometry',]$Geometry <- 1
problem_combined[problem_combined$tag1 == 'Graph Theory',]$Graph_theory <- 1
problem_combined[problem_combined$tag1 == 'Greedy',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Hashing',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Hashing',]$DS <- 1
problem_combined[problem_combined$tag1 == 'HashMap',]$Map <- 1
problem_combined[problem_combined$tag1 == 'Heap',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Heavy light decomposition',]$HL_deco <- 1
problem_combined[problem_combined$tag1 == 'Implementation',]$Implementation <- 1
problem_combined[problem_combined$tag1 == 'KMP',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Kruskal',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Line-sweep',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Maps',]$Map <- 1
problem_combined[problem_combined$tag1 == 'Matching',]$Graph_theory <- 1
problem_combined[problem_combined$tag1 == 'Math',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Matrix Exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Memoization',]$Programming <- 1
problem_combined[problem_combined$tag1 == 'Modular arithmetic',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Modular exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Number Theory',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Prime Factorization',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Prime Factorization',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Priority Queue',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Priority-Queue',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Probability',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Queue',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Recursion',]$Programming <- 1
problem_combined[problem_combined$tag1 == 'Segment Trees',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Set',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Shortest-path',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Sieve',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Sieve',]$Programming <- 1
problem_combined[problem_combined$tag1 == 'Simple-math',]$Mathematics <- 1
problem_combined[problem_combined$tag1 == 'Simulation',]$Simulation <- 1
problem_combined[problem_combined$tag1 == 'Sorting',]$Sorting <- 1
problem_combined[problem_combined$tag1 == 'Sorting',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Sqrt-Decomposition',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'Stack',]$Stack <- 1
problem_combined[problem_combined$tag1 == 'String Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag1 == 'String Algorithms',]$String_algorithm <- 1
problem_combined[problem_combined$tag1 == 'String-Manipulation',]$Programming <- 1
problem_combined[problem_combined$tag1 == 'Suffix Arrays',]$Programming <- 1
problem_combined[problem_combined$tag1 == 'Trees',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Trie',]$DS <- 1
problem_combined[problem_combined$tag1 == 'Two-pointer',]$Programming <- 1

#tag2
problem_combined[problem_combined$tag2 == 'adhoc',]$Adhoc <- 1
problem_combined[problem_combined$tag2 == 'Ad-Hoc',]$Adhoc <- 1
problem_combined[problem_combined$tag2 == 'Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Basic Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag2 == 'Basic-Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag2 == 'Bellman Ford',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'BFS',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'BFS',]$Search_tree <- 1
problem_combined[problem_combined$tag2 == 'Binary Search',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Binary Search',]$Search_tree <- 1
problem_combined[problem_combined$tag2 == 'Binary Search Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Binary Search Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag2 == 'Binary Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Binary Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag2 == 'Bipartite Graph',]$Graph_theory <- 1
problem_combined[problem_combined$tag2 == 'BIT',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag2 == 'Bit manipulation',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag2 == 'Bitmask',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag2 == 'Brute Force',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'cake-walk',]$Programming <- 1
problem_combined[problem_combined$tag2 == 'Combinatorics',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Data Structures',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Data-Structures',]$DS <- 1
problem_combined[problem_combined$tag2 == 'DFS',]$Search_tree <- 1
problem_combined[problem_combined$tag2 == 'DFS',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Dijkstra',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Disjoint Set',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Divide And Conquer',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Dynamic Programming',]$Dynamic_programming <- 1
problem_combined[problem_combined$tag2 == 'Dynamic Programming',]$Programming <- 1
problem_combined[problem_combined$tag2 == 'Fenwick Tree',]$DS <- 1
problem_combined[problem_combined$tag2 == 'FFT',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Flow',]$Programming <- 1
problem_combined[problem_combined$tag2 == 'Floyd Warshall',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Game Theory',]$Game_theory <- 1
problem_combined[problem_combined$tag2 == 'GCD',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Geometry',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Geometry',]$Geometry <- 1
problem_combined[problem_combined$tag2 == 'Graph Theory',]$Graph_theory <- 1
problem_combined[problem_combined$tag2 == 'Greedy',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Hashing',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Hashing',]$DS <- 1
problem_combined[problem_combined$tag2 == 'HashMap',]$Map <- 1
problem_combined[problem_combined$tag2 == 'Heap',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Heavy light decomposition',]$HL_deco <- 1
problem_combined[problem_combined$tag2 == 'Implementation',]$Implementation <- 1
problem_combined[problem_combined$tag2 == 'KMP',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Kruskal',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Line-sweep',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Maps',]$Map <- 1
problem_combined[problem_combined$tag2 == 'Matching',]$Graph_theory <- 1
problem_combined[problem_combined$tag2 == 'Math',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Matrix Exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Memoization',]$Programming <- 1
problem_combined[problem_combined$tag2 == 'Modular arithmetic',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Modular exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Number Theory',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Prime Factorization',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Prime Factorization',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Priority Queue',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Priority-Queue',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Probability',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Queue',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Recursion',]$Programming <- 1
problem_combined[problem_combined$tag2 == 'Segment Trees',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Set',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Shortest-path',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Sieve',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Sieve',]$Programming <- 1
problem_combined[problem_combined$tag2 == 'Simple-math',]$Mathematics <- 1
problem_combined[problem_combined$tag2 == 'Simulation',]$Simulation <- 1
problem_combined[problem_combined$tag2 == 'Sorting',]$Sorting <- 1
problem_combined[problem_combined$tag2 == 'Sorting',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Sqrt-Decomposition',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'Stack',]$Stack <- 1
problem_combined[problem_combined$tag2 == 'String Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag2 == 'String Algorithms',]$String_algorithm <- 1
problem_combined[problem_combined$tag2 == 'String-Manipulation',]$Programming <- 1
problem_combined[problem_combined$tag2 == 'Suffix Arrays',]$Programming <- 1
problem_combined[problem_combined$tag2 == 'Trees',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Trie',]$DS <- 1
problem_combined[problem_combined$tag2 == 'Two-pointer',]$Programming <- 1

#tag3
problem_combined[problem_combined$tag3 == 'adhoc',]$Adhoc <- 1
problem_combined[problem_combined$tag3 == 'Ad-Hoc',]$Adhoc <- 1
problem_combined[problem_combined$tag3 == 'Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Basic Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag3 == 'Basic-Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag3 == 'Bellman Ford',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'BFS',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'BFS',]$Search_tree <- 1
problem_combined[problem_combined$tag3 == 'Binary Search',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Binary Search',]$Search_tree <- 1
problem_combined[problem_combined$tag3 == 'Binary Search Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Binary Search Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag3 == 'Binary Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Binary Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag3 == 'Bipartite Graph',]$Graph_theory <- 1
problem_combined[problem_combined$tag3 == 'BIT',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag3 == 'Bit manipulation',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag3 == 'Bitmask',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag3 == 'Brute Force',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'cake-walk',]$Programming <- 1
problem_combined[problem_combined$tag3 == 'Combinatorics',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Data Structures',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Data-Structures',]$DS <- 1
problem_combined[problem_combined$tag3 == 'DFS',]$Search_tree <- 1
problem_combined[problem_combined$tag3 == 'DFS',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Dijkstra',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Disjoint Set',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Divide And Conquer',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Dynamic Programming',]$Dynamic_programming <- 1
problem_combined[problem_combined$tag3 == 'Dynamic Programming',]$Programming <- 1
problem_combined[problem_combined$tag3 == 'Fenwick Tree',]$DS <- 1
problem_combined[problem_combined$tag3 == 'FFT',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Flow',]$Programming <- 1
problem_combined[problem_combined$tag3 == 'Floyd Warshall',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Game Theory',]$Game_theory <- 1
problem_combined[problem_combined$tag3 == 'GCD',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Geometry',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Geometry',]$Geometry <- 1
problem_combined[problem_combined$tag3 == 'Graph Theory',]$Graph_theory <- 1
problem_combined[problem_combined$tag3 == 'Greedy',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Hashing',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Hashing',]$DS <- 1
problem_combined[problem_combined$tag3 == 'HashMap',]$Map <- 1
problem_combined[problem_combined$tag3 == 'Heap',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Heavy light decomposition',]$HL_deco <- 1
problem_combined[problem_combined$tag3 == 'Implementation',]$Implementation <- 1
problem_combined[problem_combined$tag3 == 'KMP',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Kruskal',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Line-sweep',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Maps',]$Map <- 1
problem_combined[problem_combined$tag3 == 'Matching',]$Graph_theory <- 1
problem_combined[problem_combined$tag3 == 'Math',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Matrix Exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Memoization',]$Programming <- 1
problem_combined[problem_combined$tag3 == 'Modular arithmetic',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Modular exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Number Theory',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Prime Factorization',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Prime Factorization',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Priority Queue',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Priority-Queue',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Probability',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Queue',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Recursion',]$Programming <- 1
problem_combined[problem_combined$tag3 == 'Segment Trees',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Set',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Shortest-path',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Sieve',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Sieve',]$Programming <- 1
problem_combined[problem_combined$tag3 == 'Simple-math',]$Mathematics <- 1
problem_combined[problem_combined$tag3 == 'Simulation',]$Simulation <- 1
problem_combined[problem_combined$tag3 == 'Sorting',]$Sorting <- 1
problem_combined[problem_combined$tag3 == 'Sorting',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Sqrt-Decomposition',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'Stack',]$Stack <- 1
problem_combined[problem_combined$tag3 == 'String Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag3 == 'String Algorithms',]$String_algorithm <- 1
problem_combined[problem_combined$tag3 == 'String-Manipulation',]$Programming <- 1
problem_combined[problem_combined$tag3 == 'Suffix Arrays',]$Programming <- 1
problem_combined[problem_combined$tag3 == 'Trees',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Trie',]$DS <- 1
problem_combined[problem_combined$tag3 == 'Two-pointer',]$Programming <- 1

#tag4
problem_combined[problem_combined$tag4 == 'adhoc',]$Adhoc <- 1
problem_combined[problem_combined$tag4 == 'Ad-Hoc',]$Adhoc <- 1
problem_combined[problem_combined$tag4 == 'Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Basic Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag4 == 'Basic-Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag4 == 'Bellman Ford',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'BFS',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'BFS',]$Search_tree <- 1
problem_combined[problem_combined$tag4 == 'Binary Search',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Binary Search',]$Search_tree <- 1
problem_combined[problem_combined$tag4 == 'Binary Search Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Binary Search Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag4 == 'Binary Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Binary Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag4 == 'Bipartite Graph',]$Graph_theory <- 1
problem_combined[problem_combined$tag4 == 'BIT',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag4 == 'Bit manipulation',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag4 == 'Bitmask',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag4 == 'Brute Force',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'cake-walk',]$Programming <- 1
problem_combined[problem_combined$tag4 == 'Combinatorics',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Data Structures',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Data-Structures',]$DS <- 1
problem_combined[problem_combined$tag4 == 'DFS',]$Search_tree <- 1
problem_combined[problem_combined$tag4 == 'DFS',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Dijkstra',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Disjoint Set',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Divide And Conquer',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Dynamic Programming',]$Dynamic_programming <- 1
problem_combined[problem_combined$tag4 == 'Dynamic Programming',]$Programming <- 1
problem_combined[problem_combined$tag4 == 'Fenwick Tree',]$DS <- 1
problem_combined[problem_combined$tag4 == 'FFT',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Flow',]$Programming <- 1
problem_combined[problem_combined$tag4 == 'Floyd Warshall',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Game Theory',]$Game_theory <- 1
problem_combined[problem_combined$tag4 == 'GCD',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Geometry',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Geometry',]$Geometry <- 1
problem_combined[problem_combined$tag4 == 'Graph Theory',]$Graph_theory <- 1
problem_combined[problem_combined$tag4 == 'Greedy',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Hashing',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Hashing',]$DS <- 1
problem_combined[problem_combined$tag4 == 'HashMap',]$Map <- 1
problem_combined[problem_combined$tag4 == 'Heap',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Heavy light decomposition',]$HL_deco <- 1
problem_combined[problem_combined$tag4 == 'Implementation',]$Implementation <- 1
problem_combined[problem_combined$tag4 == 'KMP',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Kruskal',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Line-sweep',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Maps',]$Map <- 1
problem_combined[problem_combined$tag4 == 'Matching',]$Graph_theory <- 1
problem_combined[problem_combined$tag4 == 'Math',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Matrix Exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Memoization',]$Programming <- 1
problem_combined[problem_combined$tag4 == 'Modular arithmetic',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Modular exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Number Theory',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Prime Factorization',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Prime Factorization',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Priority Queue',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Priority-Queue',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Probability',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Queue',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Recursion',]$Programming <- 1
problem_combined[problem_combined$tag4 == 'Segment Trees',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Set',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Shortest-path',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Sieve',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Sieve',]$Programming <- 1
problem_combined[problem_combined$tag4 == 'Simple-math',]$Mathematics <- 1
problem_combined[problem_combined$tag4 == 'Simulation',]$Simulation <- 1
problem_combined[problem_combined$tag4 == 'Sorting',]$Sorting <- 1
problem_combined[problem_combined$tag4 == 'Sorting',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Sqrt-Decomposition',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'Stack',]$Stack <- 1
problem_combined[problem_combined$tag4 == 'String Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag4 == 'String Algorithms',]$String_algorithm <- 1
problem_combined[problem_combined$tag4 == 'String-Manipulation',]$Programming <- 1
problem_combined[problem_combined$tag4 == 'Suffix Arrays',]$Programming <- 1
problem_combined[problem_combined$tag4 == 'Trees',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Trie',]$DS <- 1
problem_combined[problem_combined$tag4 == 'Two-pointer',]$Programming <- 1

#tag5
problem_combined[problem_combined$tag5 == 'adhoc',]$Adhoc <- 1
problem_combined[problem_combined$tag5 == 'Ad-Hoc',]$Adhoc <- 1
problem_combined[problem_combined$tag5 == 'Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Basic Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag5 == 'Basic-Programming',]$Basic_programming <- 1
problem_combined[problem_combined$tag5 == 'Bellman Ford',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'BFS',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'BFS',]$Search_tree <- 1
problem_combined[problem_combined$tag5 == 'Binary Search',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Binary Search',]$Search_tree <- 1
problem_combined[problem_combined$tag5 == 'Binary Search Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Binary Search Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag5 == 'Binary Tree',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Binary Tree',]$Search_tree <- 1
problem_combined[problem_combined$tag5 == 'Bipartite Graph',]$Graph_theory <- 1
problem_combined[problem_combined$tag5 == 'BIT',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag5 == 'Bit manipulation',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag5 == 'Bitmask',]$Bit_manipulation <- 1
problem_combined[problem_combined$tag5 == 'Brute Force',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'cake-walk',]$Programming <- 1
problem_combined[problem_combined$tag5 == 'Combinatorics',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Data Structures',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Data-Structures',]$DS <- 1
problem_combined[problem_combined$tag5 == 'DFS',]$Search_tree <- 1
problem_combined[problem_combined$tag5 == 'DFS',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Dijkstra',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Disjoint Set',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Divide And Conquer',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Dynamic Programming',]$Dynamic_programming <- 1
problem_combined[problem_combined$tag5 == 'Dynamic Programming',]$Programming <- 1
problem_combined[problem_combined$tag5 == 'Fenwick Tree',]$DS <- 1
problem_combined[problem_combined$tag5 == 'FFT',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Flow',]$Programming <- 1
problem_combined[problem_combined$tag5 == 'Floyd Warshall',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Game Theory',]$Game_theory <- 1
problem_combined[problem_combined$tag5 == 'GCD',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Geometry',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Geometry',]$Geometry <- 1
problem_combined[problem_combined$tag5 == 'Graph Theory',]$Graph_theory <- 1
problem_combined[problem_combined$tag5 == 'Greedy',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Hashing',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Hashing',]$DS <- 1
problem_combined[problem_combined$tag5 == 'HashMap',]$Map <- 1
problem_combined[problem_combined$tag5 == 'Heap',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Heavy light decomposition',]$HL_deco <- 1
problem_combined[problem_combined$tag5 == 'Implementation',]$Implementation <- 1
problem_combined[problem_combined$tag5 == 'KMP',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Kruskal',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Line-sweep',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Maps',]$Map <- 1
problem_combined[problem_combined$tag5 == 'Matching',]$Graph_theory <- 1
problem_combined[problem_combined$tag5 == 'Math',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Matrix Exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Memoization',]$Programming <- 1
problem_combined[problem_combined$tag5 == 'Modular arithmetic',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Modular exponentiation',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Number Theory',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Prime Factorization',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Prime Factorization',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Priority Queue',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Priority-Queue',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Probability',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Queue',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Recursion',]$Programming <- 1
problem_combined[problem_combined$tag5 == 'Segment Trees',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Set',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Shortest-path',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Sieve',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Sieve',]$Programming <- 1
problem_combined[problem_combined$tag5 == 'Simple-math',]$Mathematics <- 1
problem_combined[problem_combined$tag5 == 'Simulation',]$Simulation <- 1
problem_combined[problem_combined$tag5 == 'Sorting',]$Sorting <- 1
problem_combined[problem_combined$tag5 == 'Sorting',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Sqrt-Decomposition',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'Stack',]$Stack <- 1
problem_combined[problem_combined$tag5 == 'String Algorithms',]$Algorithms <- 1
problem_combined[problem_combined$tag5 == 'String Algorithms',]$String_algorithm <- 1
problem_combined[problem_combined$tag5 == 'String-Manipulation',]$Programming <- 1
problem_combined[problem_combined$tag5 == 'Suffix Arrays',]$Programming <- 1
problem_combined[problem_combined$tag5 == 'Trees',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Trie',]$DS <- 1
problem_combined[problem_combined$tag5 == 'Two-pointer',]$Programming <- 1

problem_combined[is.na(problem_combined)]   <- 0
problem_combined <- problem_combined[,-c(7:11)]

feature.names <- names(problem_combined)
cat("Feature Names\n")
feature.names


cat("assuming text variables are categorical & replacing them with numeric ids\n")
for (f in feature.names) {
  if (class(problem_combined[[f]])=="character") {
    levels <- unique(c(problem_combined[[f]]))
    problem_combined[[f]] <- as.integer(factor(problem_combined[[f]], levels=levels))
  }
}

problem_combined$accuraccy_measure <- (problem_combined$solved_count *100) / (problem_combined$solved_count + problem_combined$error_count) 
problem_combined$level <- as.factor(problem_combined$level)
problem_combined$Adhoc <- as.factor(problem_combined$Adhoc)
problem_combined$Algorithms <- as.factor(problem_combined$Algorithms)
problem_combined$Basic_programming <- as.factor(problem_combined$Basic_programming)
problem_combined$Graph_theory <- as.factor(problem_combined$Graph_theory)
problem_combined$HL_deco <- as.factor(problem_combined$HL_deco)
problem_combined$Implementation <- as.factor(problem_combined$Implementation)
problem_combined$Map <- as.factor(problem_combined$Map)
problem_combined$Mathematics <- as.factor(problem_combined$Mathematics)
problem_combined$Bit_manipulation <- as.factor(problem_combined$Bit_manipulation)
problem_combined$DS <- as.factor(problem_combined$DS)
problem_combined$Dynamic_programming <- as.factor(problem_combined$Dynamic_programming)
problem_combined$Game_theory <- as.factor(problem_combined$Game_theory)
problem_combined$Geometry <- as.factor(problem_combined$Geometry)
problem_combined$Programming <- as.factor(problem_combined$Programming)
problem_combined$Search_tree <- as.factor(problem_combined$Search_tree)
problem_combined$Simulation <- as.factor(problem_combined$Simulation)
problem_combined$Sorting <- as.factor(problem_combined$Sorting)
problem_combined$Stack <- as.factor(problem_combined$Stack)
problem_combined$String_algorithm <- as.factor(problem_combined$String_algorithm)

#Separating problem train and testing data sets
problem_train <- problem_combined[1:1002,]
problem_test <- problem_combined[1003:1958,]


#Getting only relevant field from Submission files
submission_train <- submission_train[!submission_train$solved_status == 'UK',]
submission_train$solved_status <- as.integer(submission_train$solved_status == 'SO')
submission_train <- submission_train[,c('user_id','problem_id','solved_status')]

# ################ 2nd approach  : Roll ups!!#############################

#Rolling Up
submission_train1 <- sqldf("
                           SELECT a.user_id,a.problem_id,sum(a.solved_status ) solved_status
                           FROM submission_train a   group by 1,2                   
                           ")

submission_train1[submission_train1$solved_status > 1,]$solved_status <- 1

#Making Collated train and testing datasets
Collated_train1 <- sqldf("
                         SELECT a.problem_id,a.solved_status , b.* , c.*
                         FROM submission_train1 a 
                         left join user_train b on a.user_id = b.user_id                         
                         left join problem_train c on a.problem_id = c.problem_id                       
                         ")

Collated_test <- sqldf("
                       SELECT a.Id,a.problem_id, b.* , c.*
                       FROM submission_test a 
                       left join user_test b on a.user_id = b.user_id                         
                       left join problem_test c on a.problem_id = c.problem_id                       
                       ")

#Removing extra problemid
Collated_train1 <- Collated_train1[,-34]
Collated_test <- Collated_test[,-34]

# Just random validation set
h<-sample(nrow(Collated_train1),2000)

# Feature selection
feature.names <- names(Collated_train1)
cat("Feature Names\n")
feature.names <- feature.names[-c(1,2,3)]
feature.names

#Creating train datasets
dval1<-xgb.DMatrix(data=data.matrix(Collated_train1[h,feature.names]),label=Collated_train1$solved_status[h])
#dtrain<-xgb.DMatrix(data=data.matrix(tra[-h,]),label=train$QuoteConversion_Flag[-h])
dtrain1 <-xgb.DMatrix(data=data.matrix(Collated_train1[,feature.names]),label=Collated_train1$solved_status)

watchlist<-list(val=dval1,train=dtrain1)
# Defining Parameters
param <- list(  objective = "binary:logistic", 
                booster = "gbtree",
                eval_metric = "error",
                eta                 = 0.01, # 0.06, #0.01,
                max_depth           = 6#, #changed from default of 8
                #                subsample           = 0.83, # 0.7
                #                colsample_bytree    = 0.77 # 0.7
                #num_parallel_tree   = 2
                # alpha = 0.0001, 
                # lambda = 1
)

# Training  : Model-1
clf1 <- xgb.train( params             = param ,
                  data               = dtrain1, 
                  nrounds            = 6000, 
                  #               nfold              = 4,
                  #               print.every.n      = 1,
                  verbose            = 1,
                  #               early.stop.round    = 150,
                  watchlist           = watchlist #,
                  #maximize            = FALSE
)

#Getting the probability prediction
pred1 <- predict(clf1, data.matrix(Collated_test[,feature.names]))
pred1 <- as.integer(pred1 > 0.76)


# Training  : Model-2
clf2 <- xgb.train( params             = param ,
                  data               = dtrain1, 
                  nrounds            = 5900, 
                  #               nfold              = 4,
                  #               print.every.n      = 1,
                  verbose            = 1,
                  #               early.stop.round    = 150,
                  watchlist           = watchlist #,
                  #maximize            = FALSE
)

#Getting the probability prediction
pred2 <- predict(clf2, data.matrix(Collated_test[,feature.names]))
pred2 <- as.integer(pred2 > 0.76)

# Training  : Model-3
clf3 <- xgb.train( params             = param ,
                   data               = dtrain1, 
                   nrounds            = 6100, 
                   #               nfold              = 4,
                   #               print.every.n      = 1,
                   verbose            = 1,
                   #               early.stop.round    = 150,
                   watchlist           = watchlist #,
                   #maximize            = FALSE
)

#Getting the probability prediction
pred3 <- predict(clf3, data.matrix(Collated_test[,feature.names]))
pred3 <- as.integer(pred3 > 0.76)




#Preparing to do a voting ensemble with different cuttoffs
soln = matrix(data = 0, nrow = 35618,ncol = 4)

soln[,1] = pred1
soln[,2] = pred2
soln[,3] = pred3

#Maximum Vote ensemble
for (i in 1:35618) {
  soln[i,4] = names(which.max(table(soln[i,1:3])))
}
ans = soln[,4]


#Making the submission
submission <- data.frame(Id=Collated_test$Id, solved_status=ans)
cat("saving the submission file\n")
write_csv(submission, "Final_FE_ensemble_solution_1.csv")

