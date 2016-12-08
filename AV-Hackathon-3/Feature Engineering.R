# Feature Engineering AV Hackathon 3

#a) Creating Dummy Variable of class factors VAR15
#a.i) is_HAXXF

is_HAXXF <- function(x) {
  if(x == "HAXXF") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train,is_HAXXF = as.factor(mapply(is_HAXXF,train$Var15)))
test_1 <- cbind(test,is_HAXXF = as.factor(mapply(is_HAXXF,test$Var15)))

#a.ii) is_HAXXC

is_HAXXC <- function(x) {
  if(x == "HAXXC") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_HAXXC = as.factor(mapply(is_HAXXC,train_1$Var15)))
test_1 <- cbind(test_1,is_HAXXC = as.factor(mapply(is_HAXXC,test_1$Var15)))

#a.iii) is_HATEM

is_HATEM <- function(x) {
  if(x == "HATEM") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_HATEM = as.factor(mapply(is_HATEM,train_1$Var15)))
test_1 <- cbind(test_1,is_HATEM = as.factor(mapply(is_HATEM,test_1$Var15)))

#a.ii) is_HATFD

is_HATFD <- function(x) {
  if(x == "HATFD") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_HATFD = as.factor(mapply(is_HATFD,train_1$Var15)))
test_1 <- cbind(test_1,is_HATFD = as.factor(mapply(is_HATFD,test_1$Var15)))





##############################################################################
#b) Creating Dummy Variable of class factors institute_state
#b.i) is_CT

is_CT <- function(x) {
  if(x == "CT") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_CT = as.factor(mapply(is_CT,train_1$institute_state)))
test_1 <- cbind(test_1,is_CT = as.factor(mapply(is_CT,test_1$institute_state)))

#b.ii) is_DC

is_DC <- function(x) {
  if(x == "DC") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_DC = as.factor(mapply(is_DC,train_1$institute_state)))
test_1 <- cbind(test_1,is_DC = as.factor(mapply(is_DC,test_1$institute_state)))

#b.iii) is_DE

is_DE <- function(x) {
  if(x == "DE") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_DE = as.factor(mapply(is_DE,train_1$institute_state)))
test_1 <- cbind(test_1,is_DE = as.factor(mapply(is_DE,test_1$institute_state)))

#b.iv) is_FL

is_FL <- function(x) {
  if(x == "FL") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_FL = as.factor(mapply(is_FL,train_1$institute_state)))
test_1 <- cbind(test_1,is_FL = as.factor(mapply(is_FL,test_1$institute_state)))

#b.v) is_GA

is_GA <- function(x) {
  if(x == "GA") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_GA = as.factor(mapply(is_GA,train_1$institute_state)))
test_1 <- cbind(test_1,is_GA = as.factor(mapply(is_GA,test_1$institute_state)))

#b.vi) is_KS

is_KS <- function(x) {
  if(x == "KS") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_KS = as.factor(mapply(is_KS,train_1$institute_state)))
test_1 <- cbind(test_1,is_KS = as.factor(mapply(is_KS,test_1$institute_state)))

#b.vi) is_KY

is_KY <- function(x) {
  if(x == "KY") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_KY = as.factor(mapply(is_KY,train_1$institute_state)))
test_1 <- cbind(test_1,is_KY = as.factor(mapply(is_KY,test_1$institute_state)))

#b.vii) is_MA

is_MA <- function(x) {
  if(x == "MA") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_MA = as.factor(mapply(is_MA,train_1$institute_state)))
test_1 <- cbind(test_1,is_MA = as.factor(mapply(is_MA,test_1$institute_state)))

#b.viii) is_MD

is_MD <- function(x) {
  if(x == "MD") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_MD = as.factor(mapply(is_MD,train_1$institute_state)))
test_1 <- cbind(test_1,is_MD = as.factor(mapply(is_MD,test_1$institute_state)))

#b.ix) is_ME

is_ME <- function(x) {
  if(x == "ME") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_ME = as.factor(mapply(is_ME,train_1$institute_state)))
test_1 <- cbind(test_1,is_ME = as.factor(mapply(is_ME,test_1$institute_state)))

#b.x) is_MI

is_MI <- function(x) {
  if(x == "MI") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_MI = as.factor(mapply(is_MI,train_1$institute_state)))
test_1 <- cbind(test_1,is_MI = as.factor(mapply(is_MI,test_1$institute_state)))

#b.xi) is_MN

is_MN <- function(x) {
  if(x == "MN") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_MN = as.factor(mapply(is_MN,train_1$institute_state)))
test_1 <- cbind(test_1,is_MN = as.factor(mapply(is_MN,test_1$institute_state)))

#b.xii) is_MS

is_MS <- function(x) {
  if(x == "MS") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_MS = as.factor(mapply(is_MS,train_1$institute_state)))
test_1 <- cbind(test_1,is_MS = as.factor(mapply(is_MS,test_1$institute_state)))

#b.xiii) is_NH

is_NH <- function(x) {
  if(x == "NH") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_NH = as.factor(mapply(is_NH,train_1$institute_state)))
test_1 <- cbind(test_1,is_NH = as.factor(mapply(is_NH,test_1$institute_state)))

#b.xiv) is_NJ

is_NJ <- function(x) {
  if(x == "NJ") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_NJ = as.factor(mapply(is_NJ,train_1$institute_state)))
test_1 <- cbind(test_1,is_NJ = as.factor(mapply(is_NJ,test_1$institute_state)))

#b.xiv) is_NY

is_NY <- function(x) {
  if(x == "NY") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_NY = as.factor(mapply(is_NY,train_1$institute_state)))
test_1 <- cbind(test_1,is_NY = as.factor(mapply(is_NY,test_1$institute_state)))

#b.xv) is_OH

is_OH <- function(x) {
  if(x == "OH") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_OH = as.factor(mapply(is_OH,train_1$institute_state)))
test_1 <- cbind(test_1,is_OH = as.factor(mapply(is_OH,test_1$institute_state)))

#b.xv) is_PA

is_PA <- function(x) {
  if(x == "PA") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_PA = as.factor(mapply(is_PA,train_1$institute_state)))
test_1 <- cbind(test_1,is_PA = as.factor(mapply(is_PA,test_1$institute_state)))

#b.xvi) is_RI

is_RI <- function(x) {
  if(x == "RI") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_RI = as.factor(mapply(is_RI,train_1$institute_state)))
test_1 <- cbind(test_1,is_RI = as.factor(mapply(is_RI,test_1$institute_state)))

#b.xvii) is_TN

is_TN <- function(x) {
  if(x == "TN") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_TN = as.factor(mapply(is_TN,train_1$institute_state)))
test_1 <- cbind(test_1,is_TN = as.factor(mapply(is_TN,test_1$institute_state)))

#b.xviii) is_VA

is_VA <- function(x) {
  if(x == "VA") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_VA = as.factor(mapply(is_VA,train_1$institute_state)))
test_1 <- cbind(test_1,is_VA = as.factor(mapply(is_VA,test_1$institute_state)))

#b.xix) is_VT

is_VT <- function(x) {
  if(x == "VT") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_VT = as.factor(mapply(is_VT,train_1$institute_state)))
test_1 <- cbind(test_1,is_VT = as.factor(mapply(is_VT,test_1$institute_state)))

#b.xx) is_WV

is_WV <- function(x) {
  if(x == "WV") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_WV = as.factor(mapply(is_WV,train_1$institute_state)))
test_1 <- cbind(test_1,is_WV = as.factor(mapply(is_WV,test_1$institute_state)))



##############################################################################
#c) Creating Dummy Variable of class factors var8
#c.i) is_rural
is_rural <- function(x) {
  if(x == "HXYJ" | x == "HXYK" | x == "HXYL") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_rural = as.factor(mapply(is_rural,train_1$Var8)))
test_1 <- cbind(test_1,is_rural = as.factor(mapply(is_rural,test_1$Var8)))

#c.ii) is_urban
is_urban <- function(x) {
  if(x == "HXYB" | x == "HXYC" | x == "HXYD" |  x == "HXYE") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_urban = as.factor(mapply(is_urban,train_1$Var8)))
test_1 <- cbind(test_1,is_urban = as.factor(mapply(is_urban,test_1$Var8)))

#c.iii) is_suburban
is_suburban <- function(x) {
  if(x == "HXYG" | x == "HXYF" | x == "HXYH" |  x == "HXYI") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_suburban = as.factor(mapply(is_suburban,train_1$Var8)))
test_1 <- cbind(test_1,is_suburban = as.factor(mapply(is_suburban,test_1$Var8)))

#c.iv) is_other
is_other <- function(x) {
  if(x == "HXYM" | x == "HXYN" | x == "HXYO") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_other = as.factor(mapply(is_other,train_1$Var8)))
test_1 <- cbind(test_1,is_other = as.factor(mapply(is_other,test_1$Var8)))

##############################################################################
#f) Creating Dummy Variable of class factors subject_area
#f.i) is_AL
is_Applearn <- function(x) {
  if(x == "Applied Learning") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_Applearn = as.factor(mapply(is_Applearn,train_1$subject_area)))
test_1 <- cbind(test_1,is_Applearn = as.factor(mapply(is_Applearn,test_1$subject_area)))

#f.ii) is_Heaspo
is_Heaspo <- function(x) {
  if(x == "Health & Sports") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_Heaspo = as.factor(mapply(is_Heaspo,train_1$subject_area)))
test_1 <- cbind(test_1,is_Heaspo = as.factor(mapply(is_Heaspo,test_1$subject_area)))

#f.iii) is_HeaCiv
is_HeaCiv <- function(x) {
  if(x == "History & Civics") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_HeaCiv = as.factor(mapply(is_HeaCiv,train_1$subject_area)))
test_1 <- cbind(test_1,is_HeaCiv = as.factor(mapply(is_HeaCiv,test_1$subject_area)))

#f.iv) is_LitLan
is_LitLan <- function(x) {
  if(x == "Literacy & Language") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_LitLan = as.factor(mapply(is_LitLan,train_1$subject_area)))
test_1 <- cbind(test_1,is_LitLan = as.factor(mapply(is_LitLan,test_1$subject_area)))

#f.v) is_MathSci
is_MathSci <- function(x) {
  if(x == "Math & Science") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_MathSci = as.factor(mapply(is_MathSci,train_1$subject_area)))
test_1 <- cbind(test_1,is_MathSci = as.factor(mapply(is_MathSci,test_1$subject_area)))

#f.vi) is_MuArt
is_MuArt <- function(x) {
  if(x == "Music & The Arts") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_MuArt = as.factor(mapply(is_MuArt,train_1$subject_area)))
test_1 <- cbind(test_1,is_MuArt = as.factor(mapply(is_MuArt,test_1$subject_area)))

#f.vii) is_SpeNee
is_SpeNee <- function(x) {
  if(x == "Special Needs") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_SpeNee = as.factor(mapply(is_SpeNee,train_1$subject_area)))
test_1 <- cbind(test_1,is_SpeNee = as.factor(mapply(is_SpeNee,test_1$subject_area)))

##############################################################################
#g) Creating Dummy Variable of class factors secondary_subject
#g.i) is_AL
is_sApplearn <- function(x) {
  if(x == "Applied Learning") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_sApplearn = as.factor(mapply(is_sApplearn,train_1$secondary_area)))
test_1 <- cbind(test_1,is_sApplearn = as.factor(mapply(is_sApplearn,test_1$secondary_area)))

#g.ii) is_Heaspo
is_sHeaspo <- function(x) {
  if(x == "Health & Sports") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_sHeaspo = as.factor(mapply(is_sHeaspo,train_1$secondary_area)))
test_1 <- cbind(test_1,is_sHeaspo = as.factor(mapply(is_sHeaspo,test_1$secondary_area)))

#g.iii) is_HeaCiv
is_sHeaCiv <- function(x) {
  if(x == "History & Civics") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_sHeaCiv = as.factor(mapply(is_sHeaCiv,train_1$secondary_area)))
test_1 <- cbind(test_1,is_sHeaCiv = as.factor(mapply(is_sHeaCiv,test_1$secondary_area)))

#g.iv) is_sLitLan
is_sLitLan <- function(x) {
  if(x == "Literacy & Language") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_sLitLan = as.factor(mapply(is_sLitLan,train_1$secondary_area)))
test_1 <- cbind(test_1,is_sLitLan = as.factor(mapply(is_sLitLan,test_1$secondary_area)))

#g.v) is_sMathSci
is_sMathSci <- function(x) {
  if(x == "Math & Science") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_sMathSci = as.factor(mapply(is_sMathSci,train_1$secondary_area)))
test_1 <- cbind(test_1,is_sMathSci = as.factor(mapply(is_sMathSci,test_1$secondary_area)))

#f.vi) is_sMuArt
is_sMuArt <- function(x) {
  if(x == "Music & The Arts") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_sMuArt = as.factor(mapply(is_sMuArt,train_1$secondary_area)))
test_1 <- cbind(test_1,is_sMuArt = as.factor(mapply(is_sMuArt,test_1$secondary_area)))

#f.vii) is_SpeNee
is_sSpeNee <- function(x) {
  if(x == "Special Needs") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_sSpeNee = as.factor(mapply(is_sSpeNee,train_1$secondary_area)))
test_1 <- cbind(test_1,is_sSpeNee = as.factor(mapply(is_sSpeNee,test_1$secondary_area)))

#f.viii) is_SNull
is_SNull <- function(x) {
  if(x == "") {
    y <- 1
  } else {
    y <- 0
  }
  return(y)
}
train_1 <- cbind(train_1,is_SNull = as.factor(mapply(is_SNull,train_1$secondary_area)))
test_1 <- cbind(test_1,is_SNull = as.factor(mapply(is_SNull,test_1$secondary_area)))



##############################################################################
# Level matching
levels(test_1$Var4) <- levels(train_1$Var4)
levels(test_1$Var10) <- levels(train_1$Var10)
levels(test_1$Var8) <- levels(train_1$Var8)
levels(test_1$Var11) <- levels(train_1$Var11)
levels(test_1$Var12) <- levels(train_1$Var12)
levels(test_1$Var13) <- levels(train_1$Var13)
levels(test_1$Var14) <- levels(train_1$Var14)
levels(test_1$Instructor_Past_Performance) <- levels(train_1$Instructor_Past_Performance)
levels(test_1$Instructor_Association_Industry_Expert) <- levels(train_1$Instructor_Association_Industry_Expert)
levels(test_1$project_subject) <- levels(train_1$project_subject)
levels(test_1$subject_area) <- levels(train_1$subject_area)
levels(test_1$secondary_subject) <- levels(train_1$secondary_subject)
levels(test_1$secondary_area) <- levels(train_1$secondary_area)
levels(test_1$Resource_Category) <- levels(train_1$Resource_Category)
levels(test_1$Resource_Sub_Category) <- levels(train_1$Resource_Sub_Category)
levels(test_1$Var23) <- levels(train_1$Var23)
levels(test_1$Var24) <- levels(train_1$Var24)
levels(test_1$is_NH) <- levels(train_1$is_NH)
levels(test_1$is_rural) <- levels(train_1$is_rural)
levels(test_1$is_urban) <- levels(train_1$is_urban)
levels(test_1$is_suburban) <- levels(train_1$is_suburban)
levels(test_1$is_other) <- levels(train_1$is_other)
