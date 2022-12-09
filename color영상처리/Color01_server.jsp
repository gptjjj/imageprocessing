<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.oreilly.servlet.multipart.*" %>
<%@ page import="javax.imageio.*" %>
<%@ page import="java.awt.image.*" %>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Color Image Processing - Server (RC 1)</title>
</head>
<body>
<%!
///////////////////////
// 전역 변수부
///////////////////////
int[][][] inImage;
int inH, inW;
int[][][] outImage;
int outH, outW;
File inFp, outFp;

// Parameter Variable
String algo, para1, para2;
String inFname, outFname;

///////////////////////
// 영상처리 함수부
///////////////////////
public void reverseImage() {
	// 반전 영상
	// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
	outH = inH;
	outW = inW;
	outImage= new int[3][outH][outW];
	/// ** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for (int i=0; i< inH; i++) {
			for (int k=0; k<inW; k++) {
				outImage[rgb][i][k] = 255 - inImage[rgb][i][k];
			}
		}
	}
}

public void addImage() {
	//add and minus
	// 반전 영상
	// (중요!) 출력 영상의 크기 결정 (알고리즘에 의존)
	outH = inH;
	outW = inW;
	outImage= new int[3][outH][outW];
	
	int value = Integer.parseInt(para1);

	for (int rgb=0; rgb<3; rgb++) {
		for (int i=0;i<inH; i++){
			for (int k=0;k<inW;k++){
				if( inImage[rgb][i][k] + value > 255)
					outImage[rgb][i][k] = 255;
				else if( inImage[rgb][i][k] + value < 0)
					outImage[rgb][i][k] = 0;
				else
					outImage[rgb][i][k] = inImage[rgb][i][k] + value;
			}
		}
	}
}

public void blackImage() {
	//Black White Processing...
	outH = inH;
	outW = inW;
	outImage= new int[3][outH][outW];
	
	
	for (int rgb=0; rgb<3; rgb++) {
		for(int i = 0 ; i < inH ; i++){
			for(int k = 0 ; k < inW ; k++){
				if(inImage[rgb][i][k] > 127){
					outImage[0][i][k] = 255;
					outImage[1][i][k] = 255;
					outImage[2][i][k] = 255;
				}else {
					outImage[0][i][k] = 0;
					outImage[1][i][k] = 0;
					outImage[2][i][k] = 0;
					
				}
			}
		} 
	}
}


public void leftrightImage(){
	//updown mirr Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	//** image Processing Algorithm
	for (int rgb=0; rgb<3; rgb++) {
		for(int i = 0 ; i < inH ; i++){
			for(int k = 0 ; k < inW ; k++){
				outImage[0][i][k] = inImage[0][inH-i-1][k];
				outImage[1][i][k] = inImage[1][inH-i-1][k];
				outImage[2][i][k] = inImage[2][inH-i-1][k];
				}
			}
		}
	}
	
public void updownImage() {
	//left n right mirr Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	//** image Processing Algorithm 
	for (int rgb=0; rgb<3; rgb++) {
		for(int i = 0 ; i < inH ; i++){
			for(int k = 0 ; k < inW ; k++){
				outImage[rgb][i][k] = inImage[rgb][i][inW-k-1];
			}
		}
	}
}

public void zoomOutImage() {
	//zoomOut Image Processing...
	outH = (int)(inH/Integer.parseInt(para1));
	outW = (int)(inW/Integer.parseInt(para1));
	outImage = new int[3][outH][outW];
	
	
	for (int rgb=0; rgb<3; rgb++) {
		for(int i = 0 ; i < inH ; i++){
			for(int k = 0 ; k < inW ; k++){
				outImage[rgb][(int)(i/Integer.parseInt(para1))][(int)(k/Integer.parseInt(para1))] = inImage[rgb][i][k];
			}
		}
	}
}
public void zoomInImage() {
	//zoomOut Image Processing...
		outH = (int)inH*Integer.parseInt(para1);
		outW = (int)inW*Integer.parseInt(para1);
		outImage = new int[3][outH][outW];
		
		
		for (int rgb=0; rgb<3; rgb++) {
			for(int i = 0 ; i < inH ; i++){
				for(int k = 0 ; k < inW ; k++){
					outImage[rgb][(int)(i/Integer.parseInt(para1))][(int)(k/Integer.parseInt(para1))] = inImage[rgb][i][k];	
					}
			}
		}
	}

public void moveImage(){
	//move Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	//** image Processing Algorithm 
	

	
	int x = Integer.parseInt(para1);
	int y = Integer.parseInt(para2);
	
	
	for (int rgb=0; rgb<3; rgb++) {
		for(int i = 0 ; i < inH ; i++){
			for(int k = 0 ; k < inW ; k++){
				if((i+y)<outH && (k+x)<outW){
				outImage[rgb][i+y][k+x] = inImage[rgb][i][k];
				}else {
					break;
				}
			}
		}
	}
}

public void rotateImage() {
	int CenterH, CenterW, newH, newW , Val;
	   double Radian, PI;
	   // PI = 3.14159265358979;
	   PI = Math.PI;
	   int degree = Integer.parseInt(para1);
	   
	   Radian = -degree * PI / 180.0; 
	   outH = (int)(Math.floor((inW) * Math.abs(Math.sin(Radian)) + (inH) * Math.abs(Math.cos(Radian))));
	   outW = (int)(Math.floor((inW) * Math.abs(Math.cos(Radian)) + (inH) * Math.abs(Math.sin(Radian))));
	   CenterH = outH / 2;
	   CenterW = outW / 2;
	   outImage = new int[3][outH][outW];
	   
	   for (int rgb = 0; rgb < 3; rgb++) {
	      for (int i = 0; i < outH; i++) {
	         for (int k = 0; k < outW; k++) {
	            newH = (int)((i - CenterH) * Math.cos(Radian) - (k - CenterW) * Math.sin(Radian) + inH / 2);
	            newW = (int)((i - CenterH) * Math.sin(Radian) + (k - CenterW) * Math.cos(Radian) + inW / 2);
	            if (newH < 0 || newH >= inH) {
	               //Val = 255;
	               outImage[0][i][k] = 55;
	               outImage[1][i][k] = 59;
	               outImage[2][i][k] = 68;
	                     
	            } else if (newW < 0 || newW >= inW) {
	               //Val = 255;
	               outImage[0][i][k] = 55;
	               outImage[1][i][k] = 59;
	               outImage[2][i][k] = 68;
	            } else {
	               Val = inImage[rgb][newH][newW];
	               outImage[rgb][i][k] = Val;
	            }
	            
	         }
	      }
	   }
}
	

public void mulImage() {
	// mul Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	//** image Processing Algorithm 
	
	int value = Integer.parseInt(para1);
	for (int rgb=0; rgb<3; rgb++) {
		for(int i = 0 ; i < inH ; i++){
			for(int k = 0 ; k < inW ; k++){
				if(outImage[rgb][i][k] * value > 255){
					outImage[rgb][i][k]=255;
					}else {
						outImage[rgb][i][k] = inImage[rgb][i][k] * value;
				}
			}
		}
	}
}

public void capImage() {
	//  cap Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	//** image Processing Algorithm 
	for (int rgb=0; rgb<3; rgb++) {
		for(int i = 0 ; i < outH ; i++){
			for(int k = 0 ; k < outW ; k++){
					outImage[rgb][i][k] = (int)((-255)*Math.pow(inImage[rgb][i][k]/127.0-1, 2)+255);
				}
			}
		}
	}

public void cupImage() {
	////(3-13) cup Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	//** image Processing Algorithm 
	for (int rgb=0; rgb<3; rgb++) {
	for(int i = 0 ; i < outH ; i++){
		for(int k = 0 ; k < outW ; k++){
				outImage[rgb][i][k] = (int)((255)*Math.pow(inImage[rgb][i][k]/127.0-1, 2));
		}
	}
}

}
public void gammaImage() {
	//gamma Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	int value = Integer.parseInt(para1);
	//double gamma = sc.nextDouble();
	//** image Processing Algorithm 
	for (int rgb=0; rgb<3; rgb++) {
		for(int i = 0 ; i < inH ; i++){
			for(int k = 0 ; k < inW ; k++){
				outImage[rgb][i][k] = (int)Math.pow(inImage[rgb][i][k]/255.0,value)*255;
			}
		}
	}
}

public void embossImage() {
	//emboss Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
				   {-1.0, 0.0, 0.0},
		 		   {0.0, 0.0, 0.0},
		 		   {0.0, 0.0,1.0}
		 		   };
	
	double [][][]tmpInImage = new double[3][outH+2][outW+2];
	
	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
			   tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}

	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   double S = 0.0;
		
				   for(int m=0;m<3;m++){
				      for(int n=0;n<3;n++){
				         S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				   tmpOutImage[rgb][i][k]=(int)S;
							}
						}
					}
				}
			
			//sum=0
				for(int i=0;i<outH;i++){
					for(int k=0;k<outW;k++){
					   tmpOutImage[rgb][i][k]+=127.0;
					}
				}
			
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   if(tmpOutImage[rgb][i][k]>255.0){
			      outImage[rgb][i][k]=255;
			   }else if(tmpOutImage[rgb][i][k]<0.0){
			      outImage[rgb][i][k]=0;
			   }else{
			      outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
						   }
						}
					}
				}
			}

public void blurImage() {
	//emboss Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
				{1.0/9, 1.0/9, 1.0/9},
			    {1.0/9, 1.0/9, 1.0/9},
			    {1.0/9, 1.0/9, 1.0/9}
			    };
			
	double [][][]tmpInImage = new double[3][outH+2][outW+2];
	
	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
			   tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}

	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   double S = 0.0;
		
				   for(int m=0;m<3;m++){
				      for(int n=0;n<3;n++){
				         S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				   tmpOutImage[rgb][i][k]=(int)S;
							}
						}
					}
				}
			
// 		//sum=0
// 		for(int i=0;i<outH;i++){
// 			for(int k=0;k<outW;k++){
// 			   tmpOutImage[rgb][i][k]+=127.0;
// 			}
// 		}
			

		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   if(tmpOutImage[rgb][i][k]>255.0){
			      outImage[rgb][i][k]=255;
			   }else if(tmpOutImage[rgb][i][k]<0.0){
			      outImage[rgb][i][k]=0;
			   }else{
			      outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
						   }
						}
					}
				}
			}

public void sharpImage() {
	//emboss Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
				{-1.0, -1.0, -1.0},
			    {-1.0, 9.0, -1.0},
			    {-1.0, -1.0, -1.0}
			    };
			
	double [][][]tmpInImage = new double[3][outH+2][outW+2];
	
	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
			   tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}

	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   double S = 0.0;
		
				   for(int m=0;m<3;m++){
				      for(int n=0;n<3;n++){
				         S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				   tmpOutImage[rgb][i][k]=(int)S;
							}
						}
					}
				}
			
// 		//sum=0
// 		for(int i=0;i<outH;i++){
// 			for(int k=0;k<outW;k++){
// 			   tmpOutImage[rgb][i][k]+=127.0;
// 			}
// 		}
			

		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   if(tmpOutImage[rgb][i][k]>255.0){
			      outImage[rgb][i][k]=255;
			   }else if(tmpOutImage[rgb][i][k]<0.0){
			      outImage[rgb][i][k]=0;
			   }else{
			      outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
						   }
						}
					}
				}
			}
				
		

public void gaussianImage() {
	//emboss Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
			 	{1.0/16, 1.0/8, 1.0/16},
			   {1.0/8, 1.0/4, 1.0/8},
			   {1.0/16, 1.0/8, 1.0/16}
			   };
			
	double [][][]tmpInImage = new double[3][outH+2][outW+2];
	
	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
			   tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}

	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   double S = 0.0;
		
				   for(int m=0;m<3;m++){
				      for(int n=0;n<3;n++){
				         S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				   tmpOutImage[rgb][i][k]=(int)S;
							}
						}
					}
				}
			
// 		//sum=0
// 		for(int i=0;i<outH;i++){
// 			for(int k=0;k<outW;k++){
// 			   tmpOutImage[rgb][i][k]+=127.0;
// 			}
// 		}
			

		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   if(tmpOutImage[rgb][i][k]>255.0){
			      outImage[rgb][i][k]=255;
			   }else if(tmpOutImage[rgb][i][k]<0.0){
			      outImage[rgb][i][k]=0;
			   }else{
			      outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
						   }
						}
					}
				}
			}

public void edgeImage() {
	//emboss Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
				{0.0, -1.0, 0.0},
			   {-1.0, 2.0, 0.0},
			   {0.0, 0.0, 0.0}
			   };
			
	double [][][]tmpInImage = new double[3][outH+2][outW+2];
	
	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
			   tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}

	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   double S = 0.0;
		
				   for(int m=0;m<3;m++){
				      for(int n=0;n<3;n++){
				         S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				   tmpOutImage[rgb][i][k]=(int)S;
							}
						}
					}
				}
			
		//sum=0
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   tmpOutImage[rgb][i][k]+=127.0;
			}
		}
			

		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   if(tmpOutImage[rgb][i][k]>255.0){
			      outImage[rgb][i][k]=255;
			   }else if(tmpOutImage[rgb][i][k]<0.0){
			      outImage[rgb][i][k]=0;
			   }else{
			      outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
						   }
						}
					}
				}
			}


public void laplaImage() {
	//emboss Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
			{0.0, 1.0, 0.0},
			   {1.0, -4.0, 1.0},
			   {0.0, 1.0, 0.0}
			   };
			
	double [][][]tmpInImage = new double[3][outH+2][outW+2];
	
	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
			   tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}

	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   double S = 0.0;
		
				   for(int m=0;m<3;m++){
				      for(int n=0;n<3;n++){
				         S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				   tmpOutImage[rgb][i][k]=(int)S;
							}
						}
					}
				}
			
		//sum=0
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   tmpOutImage[rgb][i][k]+=127.0;
			}
		}
			

		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   if(tmpOutImage[rgb][i][k]>255.0){
			      outImage[rgb][i][k]=255;
			   }else if(tmpOutImage[rgb][i][k]<0.0){
			      outImage[rgb][i][k]=0;
			   }else{
			      outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
						   }
						}
					}
				}
			}


public void LoGImage() {
	//emboss Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
			 	{0.0, 0.0, -1.0, 0.0, 0.0},
			   {0.0, -1.0, 2.0, -1.0, 0.0},
			   {-1.0, -2.0, 16.0, -2.0,-1.0},
			   {0.0, -1.0, 2.0, -1.0, 0.0},
			   {0.0, 0.0, -1.0, 0.0, 0.0}
			   };
			
	double [][][]tmpInImage = new double[3][outH+2][outW+2];
	
	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH+2;i++){
			for(int k=0;k<inW+2;k++){
			   tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}

	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   double S = 0.0;
		
				   for(int m=0;m<3;m++){
				      for(int n=0;n<3;n++){
				         S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				   tmpOutImage[rgb][i][k]=(int)S;
							}
						}
					}
				}
			
		//sum=0
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   tmpOutImage[rgb][i][k]+=127.0;
			}
		}
			

		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   if(tmpOutImage[rgb][i][k]>255.0){
			      outImage[rgb][i][k]=255;
			   }else if(tmpOutImage[rgb][i][k]<0.0){
			      outImage[rgb][i][k]=0;
			   }else{
			      outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
						   }
						}
					}
				}
			}
public void DoGImage() {
	//emboss Image Processing...
	outH = inH;
	outW = inW;
	outImage = new int[3][outH][outW];
	
	double [][]mask = {
			   {0.0, 0.0, 0.0, -1.0, -1.0, -1.0, 0.0, 0.0, 0.0},
			   {0.0, -2.0, -3.0, -3.0, -3.0, -3.0, -3.0, -2.0, 0.0},
			   {0.0, -3.0, -2.0, -1.0, -1.0, -1.0, -2.0, -3.0, 0.0},
			   {-1.0, -3.0, -1.0, 9.0, 9.0, 9.0, -1.0, -3.0, -1.0},
			   {-1.0, -3.0, -1.0, 9.0, 19.0, 9.0, -1.0, -3.0, -1.0},
			   {-1.0, -3.0, -1.0, 9.0, 9.0, 9.0, -1.0, -3.0, -1.0},
			   {0.0, -3.0, -2.0, -1.0, -1.0, -1.0, -2.0, -3.0, 0.0},
			   {0.0, -2.0, -3.0, -3.0, -3.0, -3.0, -3.0, -2.0, 0.0},
			   {0.0, 0.0, 0.0, -1.0, -1.0, -1.0, 0.0, 0.0, 0.0}
			   };
			
	double [][][]tmpInImage = new double[3][outH+8][outW+8];
	
	int [][][] tmpOutImage = new int[3][outH][outW];

	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH+4;i++){
			for(int k=0;k<inW+4;k++){
			   tmpInImage[rgb][i][k]=127.0;
			}
		}
	}
	
	for(int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   tmpInImage[rgb][i+1][k+1]=inImage[rgb][i][k];
			}
		}
	}

	//** Image Processing Algorithm **
	for (int rgb=0; rgb<3; rgb++) {
		for(int i=0;i<inH;i++){
			for(int k=0;k<inW;k++){
			   double S = 0.0;
		
				   for(int m=0;m<3;m++){
				      for(int n=0;n<3;n++){
				         S+=tmpInImage[rgb][i+m][k+n]*mask[m][n];
				   tmpOutImage[rgb][i][k]=(int)S;
							}
						}
					}
				}
			
		//sum=0
		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   tmpOutImage[rgb][i][k]+=127.0;
			}
		}
			

		for(int i=0;i<outH;i++){
			for(int k=0;k<outW;k++){
			   if(tmpOutImage[rgb][i][k]>255.0){
			      outImage[rgb][i][k]=255;
			   }else if(tmpOutImage[rgb][i][k]<0.0){
			      outImage[rgb][i][k]=0;
			   }else{
			      outImage[rgb][i][k]=(int)tmpOutImage[rgb][i][k];
						   }
						}
					}
				}
			}


	public void stretchImage() {
		outH = inH;
		outW = inW;
		outImage = new int[3][outH][outW];
		//** Image Processing Algorithm **
		int LOW = inImage[0][0][0],HIGH=inImage[0][0][0];
		for(int rgb=0; rgb<3; rgb++){
			for(int i=0;i<inH;i++)
			 	for(int k=0;k<inW;k++){
			 		if(LOW>inImage[rgb][i][k])
			 			LOW = inImage[rgb][i][k];
			 		if(HIGH<inImage[rgb][i][k])
			 			HIGH=inImage[rgb][i][k];
			 	}
		}
		for(int rgb=0; rgb<3; rgb++){
			for(int i=0;i<inH;i++){
			 	for(int k=0;k<inW;k++){
			 		double outa = (double)((inImage[rgb][i][k]-LOW)*255/(HIGH-LOW));
			 		if(outa<0.0)
			 			outa=0;
			 		else if(outa>255.0)
			 			outa=255;
			 		else
			 			outa=(int)outa;
			 		outImage[rgb][i][k] = (int)outa;
			 	}
			}
		}
	}

public void endInImage() {
	//end-in Image Processing...
			outH = inH;
			outW = inW;
			
			int LOW;
			int HIGH;
			outImage = new int[3][outH][outW];
			
			LOW = inImage[0][0][0];
			HIGH = inImage[0][0][0];
			
			for (int rgb=0; rgb<3; rgb++){
				for(int i=0;i<inH;i++){
					for(int k=0;k<inW;k++){
						int pixel = inImage[rgb][i][k];
						if(pixel < LOW){
							LOW = pixel;
						}else if (pixel > HIGH){
							HIGH = pixel;
						}
					}
				}
			}
			LOW += 50;
			HIGH -= 50;
			
			for (int rgb=0; rgb<3; rgb++) {
				for(int i=0;i<inH;i++){
					for(int k=0;k<inW;k++){
						int inValue = inImage[rgb][i][k];
						int outValue = (inValue - LOW)/(HIGH-LOW)*255;
					if(outValue > 255){
						outValue = 255;
					}else if (outValue < 0){
						outValue = 0;
						
						}
					outImage[rgb][i][k] = outValue;
					}
				}
			}
		}

public void equlizeImage() {
	
	outH=inH;
	outW=inW;

	outImage = new int[3][outH][outW];
	int histoR[] = new int[256];
	int histoG[] = new int[256];
	int histoB[] = new int[256];
	

	for(int i=0;i<inH;i++)
	 	for(int k=0;k<inW;k++){
	 		histoR[inImage[0][i][k]]++;
			histoG[inImage[1][i][k]]++;
			histoB[inImage[2][i][k]]++;
	 	}
	int sumHistoR[] = new int[256];
	int sumHistoG[] = new int[256];
	int sumHistoB[] = new int[256];
	
	for(int i=0;i<256;i++){
	 	sumHistoR[i]=0;
		sumHistoG[i]=0;
		sumHistoB[i]=0;
	}
	int sumValueR=0;
	int sumValueG=0;
	int sumValueB=0;

	for(int i=0;i<256;i++){
	 	sumValueR += histoR[i];
	 	sumHistoR[i]=sumValueR;
	 	
		sumValueG += histoG[i];
	 	sumHistoG[i]=sumValueG;
	 	
		sumValueB += histoB[i];
	 	sumHistoB[i]=sumValueB;
	}

	double normalHistoR[] = new double[256];
	double normalHistoG[] = new double[256];
	double normalHistoB[] = new double[256];
	
	for(int i=0;i<256;i++){
		normalHistoR[i]=0.0;
		normalHistoG[i]=0.0;
		normalHistoB[i]=0.0;
	}

	for(int i=0;i<256;i++){
	 	double normalR = sumHistoR[i]*(1.0/(inH*inW))*255.0;
	 	normalHistoR[i] = normalR;
	 	double normalG = sumHistoG[i]*(1.0/(inH*inW))*255.0;
	 	normalHistoG[i] = normalG;
	 	double normalB = sumHistoB[i]*(1.0/(inH*inW))*255.0;
	 	normalHistoB[i] = normalB;
	}
	for(int i=0;i<inH;i++){
	 	for(int k=0;k<inW;k++){
	 		outImage[0][i][k]=(int)normalHistoR[inImage[0][i][k]];
	 		outImage[1][i][k]=(int)normalHistoG[inImage[1][i][k]];
	 		outImage[2][i][k]=(int)normalHistoB[inImage[2][i][k]];
	 	}
	}
}






			
			
%>
<%
///////////////////////
// 메인 코드부
///////////////////////
// (0) 파라미터 넘겨 받기
MultipartRequest multi = new MultipartRequest(request, "C:/Upload/", 
		5*1024*1024, "utf-8", new DefaultFileRenamePolicy());

String tmp;
Enumeration params = multi.getParameterNames(); //주의! 파라미터 순서가 반대
tmp = (String) params.nextElement();
para2 = multi.getParameter(tmp);
tmp = (String) params.nextElement();
para1 = multi.getParameter(tmp);
tmp = (String) params.nextElement();
algo = multi.getParameter(tmp);
// File
Enumeration files = multi.getFileNames(); // 여러개 파일
tmp = (String) files.nextElement(); // 첫 파일 한개
String filename = multi.getFilesystemName(tmp);// 파일명을 추출


// (1)입력 영상 파일 처리
inFp = new File("c:/Upload/"+filename);
BufferedImage bImage = ImageIO.read(inFp);

// (2) 파일 --> 메모리
// (중요!) 입력 영상의 폭과 높이를 알아내야 함!
inW = bImage.getHeight();
inH = bImage.getWidth();
// 메모리 할당
inImage = new int[3][inH][inW];

// 읽어오기
for(int i=0; i<inH; i++) {
	for (int k=0; k<inW; k++) {
		int rgb = bImage.getRGB(i,k);  // F377D6 
		int r = (rgb >> 16) & 0xFF; // >>2Byte --->0000F3 & 0000FF --> F3
		int g = (rgb >> 8) & 0xFF; // >>1Byte --->00F377 & 0000FF --> 77			
		int b = (rgb >> 0) & 0xFF; // >>0Byte --->F377D6 & 0000FF --> D6
		inImage[0][i][k] = r;
		inImage[1][i][k] = g;
		inImage[2][i][k] = b;
	}
}


//Image Processing
	switch (algo){
		case "101":
			reverseImage(); break;
		case "102":
			addImage(); break;
		case "104":
			blackImage(); break;
		case "105":
			updownImage(); break;
		case "106":
			leftrightImage(); break;
		case "107":
			zoomOutImage(); break;
		case "108":
			zoomInImage(); break;
		case "109":
			moveImage(); break;
		case "110":
			rotateImage(); break;
		case "111":
			capImage(); break;
		case "112":
			cupImage(); break;
		case "113":
			gammaImage(); break;
		case "114":
			embossImage(); break;
		case "115":
			blurImage(); break;
		case "116":
			sharpImage(); break;
		case "117":
			gaussianImage(); break;
		case "119":
			edgeImage(); break;
		case "120":
			laplaImage(); break;
		case "121":
			LoGImage(); break;
		case "122":
			DoGImage(); break;
		case "123":
			stretchImage(); break;
		case "124":
			endInImage(); break;
		case "125":
			equlizeImage(); break;
	}

//(4) 결과를 파일로 저장하기
outFp = new File("c:/out/out_"+filename);
BufferedImage oImage 
	= new BufferedImage(outH, outW, BufferedImage.TYPE_INT_RGB); // Empty Image
//Memory --> File
for (int i=0; i< outH; i++) {
	for (int k=0; k<outW; k++) {
		int r = outImage[0][i][k];  // F3
		int g = outImage[1][i][k];  // 77
		int b = outImage[2][i][k];  // D6
		int px = 0;
		px = px | (r << 16);  // 000000 | (F30000) --> F30000
		px = px | (g << 8);   // F30000 | (007700) --> F37700
		px = px | (b << 0);   // F37700 | (0000D6) --> F377D6
		oImage.setRGB(i,k,px);
		}
	}
	ImageIO.write(oImage, "jpg", outFp);
	
	
	out.println("<h1>" + filename + " 영상 처리 완료 !! </h1>");
	String url="<p><h2><a href='http://192.168.56.101:8080/";
	url += "GrayImageProcessing/download.jsp?file="; 
	url += "out_" + filename + "'> !! 다운로드 !! </a></h2>";
	
	out.println(url);


%>
</body>
</html>