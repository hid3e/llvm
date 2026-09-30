; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind optsize uwtable
define dso_local void @drawCell(i32 noundef %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #0 {
  %4 = shl nsw i32 %0, 2
  %5 = shl nsw i32 %1, 2
  br label %6

6:                                                ; preds = %3, %10
  %7 = phi i32 [ 0, %3 ], [ %11, %10 ]
  %8 = add nuw nsw i32 %7, %5
  br label %13

9:                                                ; preds = %10
  ret void

10:                                               ; preds = %13
  %11 = add nuw nsw i32 %7, 1
  %12 = icmp eq i32 %11, 4
  br i1 %12, label %9, label %6, !llvm.loop !5

13:                                               ; preds = %6, %13
  %14 = phi i32 [ 0, %6 ], [ %16, %13 ]
  %15 = add nuw nsw i32 %14, %4
  tail call void @simPutPixel(i32 noundef %15, i32 noundef %8, i32 noundef %2) #9
  %16 = add nuw nsw i32 %14, 1
  %17 = icmp eq i32 %16, 4
  br i1 %17, label %10, label %13, !llvm.loop !7
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: optsize
declare void @simPutPixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) uwtable
define dso_local i32 @getColor(i32 noundef %0) local_unnamed_addr #3 {
  %2 = sdiv i32 %0, 256
  %3 = mul nsw i32 %2, 3
  %4 = tail call i32 @llvm.smin.i32(i32 %3, i32 255)
  %5 = tail call i32 @llvm.smax.i32(i32 %3, i32 255)
  %6 = tail call i32 @llvm.smin.i32(i32 %5, i32 510)
  %7 = tail call i32 @llvm.smax.i32(i32 %3, i32 510)
  %8 = shl i32 %4, 16
  %9 = shl nuw nsw i32 %6, 8
  %10 = add nsw i32 %7, -16843006
  %11 = add i32 %10, %8
  %12 = add i32 %11, %9
  ret i32 %12
}

; Function Attrs: nounwind optsize uwtable
define dso_local void @drawField(ptr nocapture noundef readonly %0) local_unnamed_addr #0 {
  br label %2

2:                                                ; preds = %1, %8
  %3 = phi i64 [ 0, %1 ], [ %9, %8 ]
  %4 = mul nuw nsw i64 %3, 384
  %5 = getelementptr i32, ptr %0, i64 %4
  %6 = trunc i64 %3 to i32
  br label %11

7:                                                ; preds = %8
  ret void

8:                                                ; preds = %11
  %9 = add nuw nsw i64 %3, 1
  %10 = icmp eq i64 %9, 192
  br i1 %10, label %7, label %2, !llvm.loop !8

11:                                               ; preds = %2, %11
  %12 = phi i64 [ 0, %2 ], [ %27, %11 ]
  %13 = getelementptr i32, ptr %5, i64 %12
  %14 = load i32, ptr %13, align 4, !tbaa !9
  %15 = sdiv i32 %14, 256
  %16 = mul nsw i32 %15, 3
  %17 = tail call i32 @llvm.smin.i32(i32 %16, i32 255)
  %18 = tail call i32 @llvm.smax.i32(i32 %16, i32 255)
  %19 = tail call i32 @llvm.smin.i32(i32 %18, i32 510)
  %20 = tail call i32 @llvm.smax.i32(i32 %16, i32 510)
  %21 = shl i32 %17, 16
  %22 = shl nuw nsw i32 %19, 8
  %23 = add nsw i32 %20, -16843006
  %24 = add i32 %23, %21
  %25 = add i32 %24, %22
  %26 = trunc i64 %12 to i32
  tail call void @drawCell(i32 noundef %26, i32 noundef %6, i32 noundef %25) #10
  %27 = add nuw nsw i64 %12, 1
  %28 = icmp eq i64 %27, 384
  br i1 %28, label %8, label %11, !llvm.loop !13
}

; Function Attrs: nofree norecurse nosync nounwind optsize memory(argmem: readwrite) uwtable
define dso_local void @calcField(ptr nocapture noundef readonly %0, ptr nocapture noundef writeonly %1) local_unnamed_addr #4 {
  %3 = getelementptr i32, ptr %0, i64 -384
  %4 = getelementptr i32, ptr %0, i64 384
  br label %5

5:                                                ; preds = %2, %11
  %6 = phi i64 [ 1, %2 ], [ %12, %11 ]
  %7 = mul nuw nsw i64 %6, 384
  %8 = getelementptr i32, ptr %3, i64 %7
  %9 = getelementptr i32, ptr %4, i64 %7
  br label %14

10:                                               ; preds = %11
  ret void

11:                                               ; preds = %14
  %12 = add nuw nsw i64 %6, 1
  %13 = icmp eq i64 %12, 191
  br i1 %13, label %10, label %5, !llvm.loop !14

14:                                               ; preds = %5, %14
  %15 = phi i64 [ 1, %5 ], [ %36, %14 ]
  %16 = add nuw nsw i64 %15, %7
  %17 = getelementptr inbounds i32, ptr %0, i64 %16
  %18 = load i32, ptr %17, align 4, !tbaa !9
  %19 = shl nsw i32 %18, 2
  %20 = getelementptr i32, ptr %8, i64 %15
  %21 = load i32, ptr %20, align 4, !tbaa !9
  %22 = add nsw i32 %19, %21
  %23 = getelementptr i32, ptr %9, i64 %15
  %24 = load i32, ptr %23, align 4, !tbaa !9
  %25 = add nsw i32 %22, %24
  %26 = getelementptr i32, ptr %17, i64 -1
  %27 = load i32, ptr %26, align 4, !tbaa !9
  %28 = add nsw i32 %25, %27
  %29 = getelementptr i32, ptr %17, i64 1
  %30 = load i32, ptr %29, align 4, !tbaa !9
  %31 = add nsw i32 %28, %30
  %32 = sdiv i32 %31, 8
  %33 = sdiv i32 %31, -512
  %34 = add nsw i32 %33, %32
  %35 = getelementptr inbounds i32, ptr %1, i64 %16
  store i32 %34, ptr %35, align 4, !tbaa !9
  %36 = add nuw nsw i64 %15, 1
  %37 = icmp eq i64 %36, 383
  br i1 %37, label %11, label %14, !llvm.loop !15
}

; Function Attrs: nofree norecurse nosync nounwind optsize memory(argmem: write) uwtable
define dso_local void @setHot(ptr nocapture noundef writeonly %0, i32 noundef %1, i32 noundef %2) local_unnamed_addr #5 {
  br label %4

4:                                                ; preds = %3, %10
  %5 = phi i32 [ -3, %3 ], [ %11, %10 ]
  %6 = add nsw i32 %5, %2
  %7 = mul nsw i32 %6, 384
  %8 = add i32 %7, %1
  br label %13

9:                                                ; preds = %10
  ret void

10:                                               ; preds = %13
  %11 = add nsw i32 %5, 1
  %12 = icmp eq i32 %11, 4
  br i1 %12, label %9, label %4, !llvm.loop !16

13:                                               ; preds = %4, %13
  %14 = phi i64 [ -3, %4 ], [ %19, %13 ]
  %15 = trunc i64 %14 to i32
  %16 = add i32 %8, %15
  %17 = sext i32 %16 to i64
  %18 = getelementptr inbounds i32, ptr %0, i64 %17
  store i32 65280, ptr %18, align 4, !tbaa !9
  %19 = add nsw i64 %14, 1
  %20 = icmp eq i64 %19, 4
  br i1 %20, label %10, label %13, !llvm.loop !17
}

; Function Attrs: nounwind optsize uwtable
define dso_local void @initSrc(ptr nocapture noundef writeonly %0, ptr nocapture noundef writeonly %1, ptr nocapture noundef %2, ptr nocapture noundef %3) local_unnamed_addr #0 {
  br label %6

5:                                                ; preds = %37
  ret void

6:                                                ; preds = %4, %37
  %7 = phi i64 [ 0, %4 ], [ %38, %37 ]
  %8 = tail call i32 (...) @simRand() #9
  %9 = srem i32 %8, 376
  %10 = add nsw i32 %9, 4
  %11 = getelementptr inbounds i32, ptr %0, i64 %7
  store i32 %10, ptr %11, align 4, !tbaa !9
  %12 = tail call i32 (...) @simRand() #9
  %13 = srem i32 %12, 184
  %14 = add nsw i32 %13, 4
  %15 = getelementptr inbounds i32, ptr %1, i64 %7
  store i32 %14, ptr %15, align 4, !tbaa !9
  %16 = tail call i32 (...) @simRand() #9
  %17 = srem i32 %16, 3
  %18 = add nsw i32 %17, 1
  %19 = getelementptr inbounds i32, ptr %2, i64 %7
  store i32 %18, ptr %19, align 4, !tbaa !9
  %20 = tail call i32 (...) @simRand() #9
  %21 = srem i32 %20, 3
  %22 = add nsw i32 %21, 1
  %23 = getelementptr inbounds i32, ptr %3, i64 %7
  store i32 %22, ptr %23, align 4, !tbaa !9
  %24 = tail call i32 (...) @simRand() #9
  %25 = and i32 %24, 1
  %26 = icmp eq i32 %25, 0
  br i1 %26, label %30, label %27

27:                                               ; preds = %6
  %28 = load i32, ptr %19, align 4, !tbaa !9
  %29 = sub nsw i32 0, %28
  store i32 %29, ptr %19, align 4, !tbaa !9
  br label %30

30:                                               ; preds = %27, %6
  %31 = tail call i32 (...) @simRand() #9
  %32 = and i32 %31, 1
  %33 = icmp eq i32 %32, 0
  br i1 %33, label %37, label %34

34:                                               ; preds = %30
  %35 = load i32, ptr %23, align 4, !tbaa !9
  %36 = sub nsw i32 0, %35
  store i32 %36, ptr %23, align 4, !tbaa !9
  br label %37

37:                                               ; preds = %30, %34
  %38 = add nuw nsw i64 %7, 1
  %39 = icmp eq i64 %38, 3
  br i1 %39, label %5, label %6, !llvm.loop !18
}

; Function Attrs: optsize
declare i32 @simRand(...) local_unnamed_addr #2

; Function Attrs: nofree norecurse nosync nounwind optsize memory(argmem: readwrite) uwtable
define dso_local void @moveSrc(ptr nocapture noundef %0, ptr nocapture noundef %1, ptr nocapture noundef %2, ptr nocapture noundef %3) local_unnamed_addr #4 {
  br label %6

5:                                                ; preds = %43
  ret void

6:                                                ; preds = %4, %43
  %7 = phi i64 [ 0, %4 ], [ %44, %43 ]
  %8 = getelementptr inbounds i32, ptr %2, i64 %7
  %9 = load i32, ptr %8, align 4, !tbaa !9
  %10 = getelementptr inbounds i32, ptr %0, i64 %7
  %11 = load i32, ptr %10, align 4, !tbaa !9
  %12 = add nsw i32 %11, %9
  store i32 %12, ptr %10, align 4, !tbaa !9
  %13 = getelementptr inbounds i32, ptr %3, i64 %7
  %14 = load i32, ptr %13, align 4, !tbaa !9
  %15 = getelementptr inbounds i32, ptr %1, i64 %7
  %16 = load i32, ptr %15, align 4, !tbaa !9
  %17 = add nsw i32 %16, %14
  store i32 %17, ptr %15, align 4, !tbaa !9
  %18 = load i32, ptr %10, align 4, !tbaa !9
  %19 = icmp slt i32 %18, 4
  br i1 %19, label %20, label %24

20:                                               ; preds = %6
  store i32 4, ptr %10, align 4, !tbaa !9
  %21 = load i32, ptr %8, align 4, !tbaa !9
  %22 = sub nsw i32 0, %21
  store i32 %22, ptr %8, align 4, !tbaa !9
  %23 = load i32, ptr %10, align 4, !tbaa !9
  br label %24

24:                                               ; preds = %20, %6
  %25 = phi i32 [ %23, %20 ], [ %18, %6 ]
  %26 = icmp sgt i32 %25, 379
  br i1 %26, label %27, label %30

27:                                               ; preds = %24
  store i32 379, ptr %10, align 4, !tbaa !9
  %28 = load i32, ptr %8, align 4, !tbaa !9
  %29 = sub nsw i32 0, %28
  store i32 %29, ptr %8, align 4, !tbaa !9
  br label %30

30:                                               ; preds = %27, %24
  %31 = load i32, ptr %15, align 4, !tbaa !9
  %32 = icmp slt i32 %31, 4
  br i1 %32, label %33, label %37

33:                                               ; preds = %30
  store i32 4, ptr %15, align 4, !tbaa !9
  %34 = load i32, ptr %13, align 4, !tbaa !9
  %35 = sub nsw i32 0, %34
  store i32 %35, ptr %13, align 4, !tbaa !9
  %36 = load i32, ptr %15, align 4, !tbaa !9
  br label %37

37:                                               ; preds = %33, %30
  %38 = phi i32 [ %36, %33 ], [ %31, %30 ]
  %39 = icmp sgt i32 %38, 187
  br i1 %39, label %40, label %43

40:                                               ; preds = %37
  store i32 187, ptr %15, align 4, !tbaa !9
  %41 = load i32, ptr %13, align 4, !tbaa !9
  %42 = sub nsw i32 0, %41
  store i32 %42, ptr %13, align 4, !tbaa !9
  br label %43

43:                                               ; preds = %37, %40
  %44 = add nuw nsw i64 %7, 1
  %45 = icmp eq i64 %44, 3
  br i1 %45, label %5, label %6, !llvm.loop !19
}

; Function Attrs: noreturn nounwind optsize uwtable
define dso_local void @app() local_unnamed_addr #6 {
  %1 = alloca [73728 x i32], align 16
  %2 = alloca [73728 x i32], align 16
  %3 = alloca [3 x i32], align 4
  %4 = alloca [3 x i32], align 4
  %5 = alloca [3 x i32], align 4
  %6 = alloca [3 x i32], align 4
  call void @llvm.lifetime.start.p0(i64 294912, ptr nonnull %1) #11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(294912) %1, i8 0, i64 294912, i1 false)
  call void @llvm.lifetime.start.p0(i64 294912, ptr nonnull %2) #11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(294912) %2, i8 0, i64 294912, i1 false)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %3) #11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %3, i8 0, i64 12, i1 false)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %4) #11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %4, i8 0, i64 12, i1 false)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %5) #11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %5, i8 0, i64 12, i1 false)
  call void @llvm.lifetime.start.p0(i64 12, ptr nonnull %6) #11
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(12) %6, i8 0, i64 12, i1 false)
  call void @initSrc(ptr noundef nonnull %3, ptr noundef nonnull %4, ptr noundef nonnull %5, ptr noundef nonnull %6) #10
  br label %7

7:                                                ; preds = %10, %0
  %8 = phi ptr [ %2, %0 ], [ %9, %10 ]
  %9 = phi ptr [ %1, %0 ], [ %8, %10 ]
  br label %11

10:                                               ; preds = %33
  call void @drawField(ptr noundef nonnull %9) #10
  tail call void (...) @simFlush() #9
  call void @calcField(ptr noundef nonnull %9, ptr noundef %8) #10
  call void @moveSrc(ptr noundef nonnull %3, ptr noundef nonnull %4, ptr noundef nonnull %5, ptr noundef nonnull %6) #10
  br label %7

11:                                               ; preds = %7, %33
  %12 = phi i64 [ 0, %7 ], [ %34, %33 ]
  %13 = getelementptr inbounds [3 x i32], ptr %3, i64 0, i64 %12
  %14 = load i32, ptr %13, align 4, !tbaa !9
  %15 = getelementptr inbounds [3 x i32], ptr %4, i64 0, i64 %12
  %16 = load i32, ptr %15, align 4, !tbaa !9
  br label %17

17:                                               ; preds = %22, %11
  %18 = phi i32 [ -3, %11 ], [ %23, %22 ]
  %19 = add nsw i32 %18, %16
  %20 = mul nsw i32 %19, 384
  %21 = add i32 %20, %14
  br label %25

22:                                               ; preds = %25
  %23 = add nsw i32 %18, 1
  %24 = icmp eq i32 %23, 4
  br i1 %24, label %33, label %17, !llvm.loop !16

25:                                               ; preds = %25, %17
  %26 = phi i64 [ -3, %17 ], [ %31, %25 ]
  %27 = trunc i64 %26 to i32
  %28 = add i32 %21, %27
  %29 = sext i32 %28 to i64
  %30 = getelementptr inbounds i32, ptr %9, i64 %29
  store i32 65280, ptr %30, align 4, !tbaa !9
  %31 = add nsw i64 %26, 1
  %32 = icmp eq i64 %31, 4
  br i1 %32, label %22, label %25, !llvm.loop !17

33:                                               ; preds = %22
  %34 = add nuw nsw i64 %12, 1
  %35 = icmp eq i64 %34, 3
  br i1 %35, label %10, label %11, !llvm.loop !20
}

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #7

; Function Attrs: optsize
declare void @simFlush(...) local_unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smin.i32(i32, i32) #8

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i32 @llvm.smax.i32(i32, i32) #8

attributes #0 = { nounwind optsize uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { optsize "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nofree norecurse nosync nounwind optsize willreturn memory(none) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nofree norecurse nosync nounwind optsize memory(argmem: readwrite) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nofree norecurse nosync nounwind optsize memory(argmem: write) uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { noreturn nounwind optsize uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #8 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #9 = { nounwind optsize }
attributes #10 = { optsize }
attributes #11 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"Ubuntu clang version 18.1.3 (1ubuntu1)"}
!5 = distinct !{!5, !6}
!6 = !{!"llvm.loop.mustprogress"}
!7 = distinct !{!7, !6}
!8 = distinct !{!8, !6}
!9 = !{!10, !10, i64 0}
!10 = !{!"int", !11, i64 0}
!11 = !{!"omnipotent char", !12, i64 0}
!12 = !{!"Simple C/C++ TBAA"}
!13 = distinct !{!13, !6}
!14 = distinct !{!14, !6}
!15 = distinct !{!15, !6}
!16 = distinct !{!16, !6}
!17 = distinct !{!17, !6}
!18 = distinct !{!18, !6}
!19 = distinct !{!19, !6}
!20 = distinct !{!20, !6}
