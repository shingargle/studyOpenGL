//
//  ViewController.m
//  StudyOpenGL
//
//  Created by sogata on 2014/05/15.
//  Copyright (c) 2014年 RICOH. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
- (void) viewDidAppear:(BOOL)animated
{
    // GLKViewController を使う準備
    [super viewDidAppear:animated];
    ((GLKView *)self.view).context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2]; //OpenGL ES 2.0になる
    EAGLContext.currentContext = ((GLKView*)self.view).context;
    mEffect = [[GLKBaseEffect alloc] init];
    // ------------
    
    glGenBuffers(1, &mBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, mBuffer);
    
    static float wData[ 6 ];
    for ( int i = 0; i < 3; i++ )
    {
        wData[ i * 2 + 0 ] = sin( 2 * M_PI * i / 3 );
        wData[ i * 2 + 1 ] = cos( 2 * M_PI * i / 3 );
    }
    glBufferData(GL_ARRAY_BUFFER, sizeof(wData), wData, GL_STATIC_DRAW);
    
    //----------
    glGenBuffers(1, &tBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, tBuffer);
    static float tData[] =
    {
        0,   0.5,
        -0.5,  -0.5,
        0.5,  -0.5,
    };
    glBufferData(GL_ARRAY_BUFFER, sizeof(tData), tData, GL_STATIC_DRAW);
}

- (void) viewWillDisappear:(BOOL)animated
{
    // 使い終わったら片付ける
    [super viewWillDisappear:animated];
    mEffect = nil;
    ((GLKView*)self.view).context = nil;
    // -----------
}

- (void) update
{
    mTime += self.timeSinceLastUpdate;
}

//GLKBaseEffect を使って３角形を描画する。(3次元にお試し改良)
// http://paraiso.moo.jp/wp/?p=61
- (void) glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    mEffect.transform.modelviewMatrix = GLKMatrix4MakeYRotation(mTime);
    mEffect.transform.projectionMatrix = GLKMatrix4MakeScale( 1, view.bounds.size.width / view.bounds.size.height, 1 );
    [mEffect prepareToDraw];

    //頂点データを有効
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glBindBuffer(GL_ARRAY_BUFFER, tBuffer);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 8, 0);
    /*
     引数１：        種類：頂点データ
     引数２：      次元数：２
     引数３：          型：float
     引数４：ノーマライズ：しない（引数が整数で与えられた時のコンバージョンを方法）
     引数５：  ストライド：８
     引数６：    実データ：sData
     */
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    glDisableVertexAttribArray(GLKVertexAttribPosition);
}


@end