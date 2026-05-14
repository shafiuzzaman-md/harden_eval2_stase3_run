; ModuleID = 'out/eval2_linux/path_a/kbmi_net_line71/harness.bc'
source_filename = "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_kbmi_net_line71.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [8 x i8] c"sep_pos\00", align 1
@.str.1 = private unnamed_addr constant [15 x i8] c"shellcode_byte\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"filler_byte\00", align 1
@g_message_buffer = internal global [1024 x i8] zeroinitializer, align 16, !dbg !0

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !252 {
  %1 = alloca i32, align 4
  %2 = alloca i64, align 8
  %3 = alloca i8, align 1
  %4 = alloca i8, align 1
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata i64* %2, metadata !258, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.declare(metadata i8* %3, metadata !260, metadata !DIExpression()), !dbg !261
  call void @llvm.dbg.declare(metadata i8* %4, metadata !262, metadata !DIExpression()), !dbg !263
  %5 = bitcast i64* %2 to i8*, !dbg !264
  call void @klee_make_symbolic(i8* noundef %5, i64 noundef 8, i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0)), !dbg !265
  call void @klee_make_symbolic(i8* noundef %3, i64 noundef 1, i8* noundef getelementptr inbounds ([15 x i8], [15 x i8]* @.str.1, i64 0, i64 0)), !dbg !266
  call void @klee_make_symbolic(i8* noundef %4, i64 noundef 1, i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2, i64 0, i64 0)), !dbg !267
  %6 = load i64, i64* %2, align 8, !dbg !268
  %7 = icmp ult i64 %6, 1023, !dbg !269
  %8 = zext i1 %7 to i32, !dbg !269
  %9 = sext i32 %8 to i64, !dbg !268
  call void @klee_assume(i64 noundef %9), !dbg !270
  %10 = load i8, i8* %3, align 1, !dbg !271
  %11 = zext i8 %10 to i32, !dbg !271
  %12 = icmp eq i32 %11, 144, !dbg !272
  %13 = zext i1 %12 to i32, !dbg !272
  %14 = sext i32 %13 to i64, !dbg !271
  call void @klee_assume(i64 noundef %14), !dbg !273
  %15 = load i8, i8* %4, align 1, !dbg !274
  %16 = zext i8 %15 to i32, !dbg !274
  %17 = icmp ne i32 %16, 0, !dbg !275
  %18 = zext i1 %17 to i32, !dbg !275
  %19 = sext i32 %18 to i64, !dbg !274
  call void @klee_assume(i64 noundef %19), !dbg !276
  %20 = load i8, i8* %4, align 1, !dbg !277
  %21 = zext i8 %20 to i32, !dbg !277
  %22 = trunc i32 %21 to i8, !dbg !278
  %23 = zext i8 %22 to i32, !dbg !278
  %24 = call i8* @memset(i8* getelementptr inbounds ([1024 x i8], [1024 x i8]* @g_message_buffer, i64 0, i64 0), i32 %23, i64 1024), !dbg !278
  %25 = load i64, i64* %2, align 8, !dbg !279
  %26 = getelementptr inbounds [1024 x i8], [1024 x i8]* @g_message_buffer, i64 0, i64 %25, !dbg !280
  store i8 0, i8* %26, align 1, !dbg !281
  %27 = load i8, i8* %3, align 1, !dbg !282
  %28 = load i64, i64* %2, align 8, !dbg !283
  %29 = add i64 %28, 1, !dbg !284
  %30 = getelementptr inbounds [1024 x i8], [1024 x i8]* @g_message_buffer, i64 0, i64 %29, !dbg !285
  store i8 %27, i8* %30, align 1, !dbg !286
  %31 = call i32 @kbmi_pre_routing_hook(i8* noundef getelementptr inbounds ([1024 x i8], [1024 x i8]* @g_message_buffer, i64 0, i64 0)), !dbg !287
  ret i32 0, !dbg !288
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #2

declare void @klee_assume(i64 noundef) #2

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @kbmi_pre_routing_hook(i8* noundef %0) #0 !dbg !289 {
  %2 = alloca i8*, align 8
  %3 = alloca [1024 x i8], align 16
  %4 = alloca i32, align 4
  %5 = alloca i8*, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i8*, align 8
  %11 = alloca i64, align 8
  %12 = alloca i8*, align 8
  %13 = alloca i64, align 8
  %14 = alloca i8, align 1
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !292, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.declare(metadata [1024 x i8]* %3, metadata !294, metadata !DIExpression()), !dbg !295
  %15 = bitcast [1024 x i8]* %3 to i8*, !dbg !295
  %16 = call i8* @memset(i8* %15, i32 0, i64 1024), !dbg !295
  call void @llvm.dbg.declare(metadata i32* %4, metadata !296, metadata !DIExpression()), !dbg !297
  store i32 1, i32* %4, align 4, !dbg !297
  %17 = load i8*, i8** %2, align 8, !dbg !298
  %18 = icmp ne i8* %17, null, !dbg !298
  br i1 %18, label %20, label %19, !dbg !300

19:                                               ; preds = %1
  br label %97, !dbg !301

20:                                               ; preds = %1
  call void @llvm.dbg.declare(metadata i8** %5, metadata !302, metadata !DIExpression()), !dbg !303
  %21 = load i8*, i8** %2, align 8, !dbg !304
  %22 = call i8* @memchr(i8* noundef %21, i32 noundef 0, i64 noundef 1024) #8, !dbg !305
  store i8* %22, i8** %5, align 8, !dbg !303
  %23 = load i8*, i8** %5, align 8, !dbg !306
  %24 = icmp eq i8* %23, null, !dbg !308
  br i1 %24, label %25, label %26, !dbg !309

25:                                               ; preds = %20
  br label %97, !dbg !310

26:                                               ; preds = %20
  %27 = load i8*, i8** %5, align 8, !dbg !311
  %28 = load i8*, i8** %2, align 8, !dbg !313
  %29 = ptrtoint i8* %27 to i64, !dbg !314
  %30 = ptrtoint i8* %28 to i64, !dbg !314
  %31 = sub i64 %29, %30, !dbg !314
  %32 = icmp eq i64 %31, 1023, !dbg !315
  br i1 %32, label %33, label %34, !dbg !316

33:                                               ; preds = %26
  br label %97, !dbg !317

34:                                               ; preds = %26
  call void @llvm.dbg.declare(metadata i8** %6, metadata !318, metadata !DIExpression()), !dbg !319
  %35 = load i8*, i8** %5, align 8, !dbg !320
  %36 = getelementptr inbounds i8, i8* %35, i64 1, !dbg !321
  store i8* %36, i8** %6, align 8, !dbg !319
  call void @llvm.dbg.declare(metadata i8** %7, metadata !322, metadata !DIExpression()), !dbg !323
  %37 = load i8*, i8** %2, align 8, !dbg !324
  %38 = getelementptr inbounds i8, i8* %37, i64 1024, !dbg !325
  store i8* %38, i8** %7, align 8, !dbg !323
  call void @llvm.dbg.declare(metadata i64* %8, metadata !326, metadata !DIExpression()), !dbg !327
  %39 = load i8*, i8** %7, align 8, !dbg !328
  %40 = load i8*, i8** %6, align 8, !dbg !329
  %41 = ptrtoint i8* %39 to i64, !dbg !330
  %42 = ptrtoint i8* %40 to i64, !dbg !330
  %43 = sub i64 %41, %42, !dbg !330
  store i64 %43, i64* %8, align 8, !dbg !327
  %44 = load i64, i64* %8, align 8, !dbg !331
  %45 = icmp ugt i64 %44, 1024, !dbg !333
  br i1 %45, label %46, label %47, !dbg !334

46:                                               ; preds = %34
  br label %97, !dbg !335

47:                                               ; preds = %34
  %48 = getelementptr inbounds [1024 x i8], [1024 x i8]* %3, i64 0, i64 0, !dbg !336
  %49 = load i8*, i8** %6, align 8, !dbg !337
  %50 = load i64, i64* %8, align 8, !dbg !338
  %51 = call i8* @memcpy(i8* %48, i8* %49, i64 %50), !dbg !336
  call void @llvm.dbg.declare(metadata i64* %9, metadata !339, metadata !DIExpression()), !dbg !341
  %52 = call i64 @sysconf(i32 noundef 30) #9, !dbg !342
  store i64 %52, i64* %9, align 8, !dbg !341
  %53 = load i64, i64* %9, align 8, !dbg !343
  %54 = icmp sle i64 %53, 0, !dbg !345
  br i1 %54, label %55, label %56, !dbg !346

55:                                               ; preds = %47
  store i64 4096, i64* %9, align 8, !dbg !347
  br label %56, !dbg !348

56:                                               ; preds = %55, %47
  call void @llvm.dbg.declare(metadata i8** %10, metadata !349, metadata !DIExpression()), !dbg !350
  %57 = load i64, i64* %9, align 8, !dbg !351
  %58 = call i8* @mmap(i8* noundef null, i64 noundef %57, i32 noundef 3, i32 noundef 34, i32 noundef -1, i64 noundef 0) #9, !dbg !352
  store i8* %58, i8** %10, align 8, !dbg !350
  %59 = load i8*, i8** %10, align 8, !dbg !353
  %60 = icmp ne i8* %59, inttoptr (i64 -1 to i8*), !dbg !355
  br i1 %60, label %61, label %81, !dbg !356

61:                                               ; preds = %56
  call void @llvm.dbg.declare(metadata i64* %11, metadata !357, metadata !DIExpression()), !dbg !359
  %62 = load i64, i64* %8, align 8, !dbg !360
  %63 = load i64, i64* %9, align 8, !dbg !361
  %64 = icmp ult i64 %62, %63, !dbg !362
  br i1 %64, label %65, label %67, !dbg !360

65:                                               ; preds = %61
  %66 = load i64, i64* %8, align 8, !dbg !363
  br label %69, !dbg !360

67:                                               ; preds = %61
  %68 = load i64, i64* %9, align 8, !dbg !364
  br label %69, !dbg !360

69:                                               ; preds = %67, %65
  %70 = phi i64 [ %66, %65 ], [ %68, %67 ], !dbg !360
  store i64 %70, i64* %11, align 8, !dbg !359
  %71 = load i8*, i8** %10, align 8, !dbg !365
  %72 = getelementptr inbounds [1024 x i8], [1024 x i8]* %3, i64 0, i64 0, !dbg !366
  %73 = load i64, i64* %11, align 8, !dbg !367
  %74 = call i8* @memcpy(i8* %71, i8* %72, i64 %73), !dbg !366
  %75 = load i8*, i8** %10, align 8, !dbg !368
  %76 = load i64, i64* %9, align 8, !dbg !369
  %77 = call i32 @mprotect(i8* noundef %75, i64 noundef %76, i32 noundef 7) #9, !dbg !370
  %78 = load i8*, i8** %10, align 8, !dbg !371
  %79 = load i64, i64* %9, align 8, !dbg !372
  %80 = call i32 @munmap(i8* noundef %78, i64 noundef %79) #9, !dbg !373
  br label %81, !dbg !374

81:                                               ; preds = %69, %56
  call void @llvm.dbg.declare(metadata i8** %12, metadata !375, metadata !DIExpression()), !dbg !376
  %82 = call noalias i8* @malloc(i64 noundef 16) #9, !dbg !377
  store i8* %82, i8** %12, align 8, !dbg !376
  %83 = load i8*, i8** %12, align 8, !dbg !378
  %84 = call i8* @memset(i8* %83, i32 0, i64 16), !dbg !379
  call void @llvm.dbg.declare(metadata i64* %13, metadata !380, metadata !DIExpression()), !dbg !381
  %85 = getelementptr inbounds [1024 x i8], [1024 x i8]* %3, i64 0, i64 0, !dbg !382
  %86 = load i8, i8* %85, align 16, !dbg !382
  %87 = zext i8 %86 to i32, !dbg !382
  %88 = and i32 %87, 15, !dbg !383
  %89 = sext i32 %88 to i64, !dbg !384
  %90 = add i64 32, %89, !dbg !385
  store i64 %90, i64* %13, align 8, !dbg !381
  call void @llvm.dbg.declare(metadata i8* %14, metadata !386, metadata !DIExpression()), !dbg !388
  %91 = load i8*, i8** %12, align 8, !dbg !389
  %92 = load i64, i64* %13, align 8, !dbg !391
  %93 = getelementptr inbounds i8, i8* %91, i64 %92, !dbg !389
  %94 = load i8, i8* %93, align 1, !dbg !389
  store volatile i8 %94, i8* %14, align 1, !dbg !392
  %95 = load volatile i8, i8* %14, align 1, !dbg !393
  %96 = load i8*, i8** %12, align 8, !dbg !394
  call void @free(i8* noundef %96) #9, !dbg !395
  br label %97, !dbg !395

97:                                               ; preds = %81, %46, %33, %25, %19
  call void @llvm.dbg.label(metadata !396), !dbg !397
  %98 = load i32, i32* %4, align 4, !dbg !398
  ret i32 %98, !dbg !399
}

; Function Attrs: nounwind readonly willreturn
declare i8* @memchr(i8* noundef, i32 noundef, i64 noundef) #4

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #5

; Function Attrs: nounwind
declare i64 @sysconf(i32 noundef) #6

; Function Attrs: nounwind
declare i8* @mmap(i8* noundef, i64 noundef, i32 noundef, i32 noundef, i32 noundef, i64 noundef) #6

; Function Attrs: nounwind
declare i32 @mprotect(i8* noundef, i64 noundef, i32 noundef) #6

; Function Attrs: nounwind
declare i32 @munmap(i8* noundef, i64 noundef) #6

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #6

; Function Attrs: nounwind
declare void @free(i8* noundef) #6

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memcpy(i8* noundef %0, i8* noundef %1, i64 noundef %2) #7 !dbg !400 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  %8 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !406, metadata !DIExpression()), !dbg !407
  store i8* %1, i8** %5, align 8
  call void @llvm.dbg.declare(metadata i8** %5, metadata !408, metadata !DIExpression()), !dbg !409
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !410, metadata !DIExpression()), !dbg !411
  call void @llvm.dbg.declare(metadata i8** %7, metadata !412, metadata !DIExpression()), !dbg !413
  %9 = load i8*, i8** %4, align 8, !dbg !414
  store i8* %9, i8** %7, align 8, !dbg !413
  call void @llvm.dbg.declare(metadata i8** %8, metadata !415, metadata !DIExpression()), !dbg !418
  %10 = load i8*, i8** %5, align 8, !dbg !419
  store i8* %10, i8** %8, align 8, !dbg !418
  br label %11, !dbg !420

11:                                               ; preds = %15, %3
  %12 = load i64, i64* %6, align 8, !dbg !421
  %13 = add i64 %12, -1, !dbg !421
  store i64 %13, i64* %6, align 8, !dbg !421
  %14 = icmp ugt i64 %12, 0, !dbg !422
  br i1 %14, label %15, label %21, !dbg !420

15:                                               ; preds = %11
  %16 = load i8*, i8** %8, align 8, !dbg !423
  %17 = getelementptr inbounds i8, i8* %16, i32 1, !dbg !423
  store i8* %17, i8** %8, align 8, !dbg !423
  %18 = load i8, i8* %16, align 1, !dbg !424
  %19 = load i8*, i8** %7, align 8, !dbg !425
  %20 = getelementptr inbounds i8, i8* %19, i32 1, !dbg !425
  store i8* %20, i8** %7, align 8, !dbg !425
  store i8 %18, i8* %19, align 1, !dbg !426
  br label %11, !dbg !420, !llvm.loop !427

21:                                               ; preds = %11
  %22 = load i8*, i8** %4, align 8, !dbg !429
  ret i8* %22, !dbg !430
}

; Function Attrs: noinline nounwind uwtable
define dso_local i8* @memset(i8* noundef %0, i32 noundef %1, i64 noundef %2) #7 !dbg !431 {
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i64, align 8
  %7 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !435, metadata !DIExpression()), !dbg !436
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !437, metadata !DIExpression()), !dbg !438
  store i64 %2, i64* %6, align 8
  call void @llvm.dbg.declare(metadata i64* %6, metadata !439, metadata !DIExpression()), !dbg !440
  call void @llvm.dbg.declare(metadata i8** %7, metadata !441, metadata !DIExpression()), !dbg !442
  %8 = load i8*, i8** %4, align 8, !dbg !443
  store i8* %8, i8** %7, align 8, !dbg !442
  br label %9, !dbg !444

9:                                                ; preds = %13, %3
  %10 = load i64, i64* %6, align 8, !dbg !445
  %11 = add i64 %10, -1, !dbg !445
  store i64 %11, i64* %6, align 8, !dbg !445
  %12 = icmp ugt i64 %10, 0, !dbg !446
  br i1 %12, label %13, label %18, !dbg !444

13:                                               ; preds = %9
  %14 = load i32, i32* %5, align 4, !dbg !447
  %15 = trunc i32 %14 to i8, !dbg !447
  %16 = load i8*, i8** %7, align 8, !dbg !448
  %17 = getelementptr inbounds i8, i8* %16, i32 1, !dbg !448
  store i8* %17, i8** %7, align 8, !dbg !448
  store i8 %15, i8* %16, align 1, !dbg !449
  br label %9, !dbg !444, !llvm.loop !450

18:                                               ; preds = %9
  %19 = load i8*, i8** %4, align 8, !dbg !451
  ret i8* %19, !dbg !452
}

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { argmemonly nofree nounwind willreturn writeonly }
attributes #4 = { nounwind readonly willreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { argmemonly nofree nounwind willreturn }
attributes #6 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { nounwind readonly willreturn }
attributes #9 = { nounwind }

!llvm.dbg.cu = !{!2, !240, !242}
!llvm.module.flags = !{!244, !245, !246, !247, !248, !249, !250}
!llvm.ident = !{!251, !251, !251}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_message_buffer", scope: !2, file: !236, line: 51, type: !237, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !226, globals: !235, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_kbmi_net_line71.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "dc433410b57f080815b1195167b330c6")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !6, line: 71, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/confname.h", directory: "", checksumkind: CSK_MD5, checksum: "8d90d434eef5f225e60d07c486f475d0")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13, !14, !15, !16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42, !43, !44, !45, !46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !58, !59, !60, !61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !123, !124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !152, !153, !154, !155, !156, !157, !158, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195, !196, !197, !198, !199, !200, !201, !202, !203, !204, !205, !206, !207, !208, !209, !210, !211, !212, !213, !214, !215, !216, !217, !218, !219, !220, !221, !222, !223, !224, !225}
!9 = !DIEnumerator(name: "_SC_ARG_MAX", value: 0)
!10 = !DIEnumerator(name: "_SC_CHILD_MAX", value: 1)
!11 = !DIEnumerator(name: "_SC_CLK_TCK", value: 2)
!12 = !DIEnumerator(name: "_SC_NGROUPS_MAX", value: 3)
!13 = !DIEnumerator(name: "_SC_OPEN_MAX", value: 4)
!14 = !DIEnumerator(name: "_SC_STREAM_MAX", value: 5)
!15 = !DIEnumerator(name: "_SC_TZNAME_MAX", value: 6)
!16 = !DIEnumerator(name: "_SC_JOB_CONTROL", value: 7)
!17 = !DIEnumerator(name: "_SC_SAVED_IDS", value: 8)
!18 = !DIEnumerator(name: "_SC_REALTIME_SIGNALS", value: 9)
!19 = !DIEnumerator(name: "_SC_PRIORITY_SCHEDULING", value: 10)
!20 = !DIEnumerator(name: "_SC_TIMERS", value: 11)
!21 = !DIEnumerator(name: "_SC_ASYNCHRONOUS_IO", value: 12)
!22 = !DIEnumerator(name: "_SC_PRIORITIZED_IO", value: 13)
!23 = !DIEnumerator(name: "_SC_SYNCHRONIZED_IO", value: 14)
!24 = !DIEnumerator(name: "_SC_FSYNC", value: 15)
!25 = !DIEnumerator(name: "_SC_MAPPED_FILES", value: 16)
!26 = !DIEnumerator(name: "_SC_MEMLOCK", value: 17)
!27 = !DIEnumerator(name: "_SC_MEMLOCK_RANGE", value: 18)
!28 = !DIEnumerator(name: "_SC_MEMORY_PROTECTION", value: 19)
!29 = !DIEnumerator(name: "_SC_MESSAGE_PASSING", value: 20)
!30 = !DIEnumerator(name: "_SC_SEMAPHORES", value: 21)
!31 = !DIEnumerator(name: "_SC_SHARED_MEMORY_OBJECTS", value: 22)
!32 = !DIEnumerator(name: "_SC_AIO_LISTIO_MAX", value: 23)
!33 = !DIEnumerator(name: "_SC_AIO_MAX", value: 24)
!34 = !DIEnumerator(name: "_SC_AIO_PRIO_DELTA_MAX", value: 25)
!35 = !DIEnumerator(name: "_SC_DELAYTIMER_MAX", value: 26)
!36 = !DIEnumerator(name: "_SC_MQ_OPEN_MAX", value: 27)
!37 = !DIEnumerator(name: "_SC_MQ_PRIO_MAX", value: 28)
!38 = !DIEnumerator(name: "_SC_VERSION", value: 29)
!39 = !DIEnumerator(name: "_SC_PAGESIZE", value: 30)
!40 = !DIEnumerator(name: "_SC_RTSIG_MAX", value: 31)
!41 = !DIEnumerator(name: "_SC_SEM_NSEMS_MAX", value: 32)
!42 = !DIEnumerator(name: "_SC_SEM_VALUE_MAX", value: 33)
!43 = !DIEnumerator(name: "_SC_SIGQUEUE_MAX", value: 34)
!44 = !DIEnumerator(name: "_SC_TIMER_MAX", value: 35)
!45 = !DIEnumerator(name: "_SC_BC_BASE_MAX", value: 36)
!46 = !DIEnumerator(name: "_SC_BC_DIM_MAX", value: 37)
!47 = !DIEnumerator(name: "_SC_BC_SCALE_MAX", value: 38)
!48 = !DIEnumerator(name: "_SC_BC_STRING_MAX", value: 39)
!49 = !DIEnumerator(name: "_SC_COLL_WEIGHTS_MAX", value: 40)
!50 = !DIEnumerator(name: "_SC_EQUIV_CLASS_MAX", value: 41)
!51 = !DIEnumerator(name: "_SC_EXPR_NEST_MAX", value: 42)
!52 = !DIEnumerator(name: "_SC_LINE_MAX", value: 43)
!53 = !DIEnumerator(name: "_SC_RE_DUP_MAX", value: 44)
!54 = !DIEnumerator(name: "_SC_CHARCLASS_NAME_MAX", value: 45)
!55 = !DIEnumerator(name: "_SC_2_VERSION", value: 46)
!56 = !DIEnumerator(name: "_SC_2_C_BIND", value: 47)
!57 = !DIEnumerator(name: "_SC_2_C_DEV", value: 48)
!58 = !DIEnumerator(name: "_SC_2_FORT_DEV", value: 49)
!59 = !DIEnumerator(name: "_SC_2_FORT_RUN", value: 50)
!60 = !DIEnumerator(name: "_SC_2_SW_DEV", value: 51)
!61 = !DIEnumerator(name: "_SC_2_LOCALEDEF", value: 52)
!62 = !DIEnumerator(name: "_SC_PII", value: 53)
!63 = !DIEnumerator(name: "_SC_PII_XTI", value: 54)
!64 = !DIEnumerator(name: "_SC_PII_SOCKET", value: 55)
!65 = !DIEnumerator(name: "_SC_PII_INTERNET", value: 56)
!66 = !DIEnumerator(name: "_SC_PII_OSI", value: 57)
!67 = !DIEnumerator(name: "_SC_POLL", value: 58)
!68 = !DIEnumerator(name: "_SC_SELECT", value: 59)
!69 = !DIEnumerator(name: "_SC_UIO_MAXIOV", value: 60)
!70 = !DIEnumerator(name: "_SC_IOV_MAX", value: 60)
!71 = !DIEnumerator(name: "_SC_PII_INTERNET_STREAM", value: 61)
!72 = !DIEnumerator(name: "_SC_PII_INTERNET_DGRAM", value: 62)
!73 = !DIEnumerator(name: "_SC_PII_OSI_COTS", value: 63)
!74 = !DIEnumerator(name: "_SC_PII_OSI_CLTS", value: 64)
!75 = !DIEnumerator(name: "_SC_PII_OSI_M", value: 65)
!76 = !DIEnumerator(name: "_SC_T_IOV_MAX", value: 66)
!77 = !DIEnumerator(name: "_SC_THREADS", value: 67)
!78 = !DIEnumerator(name: "_SC_THREAD_SAFE_FUNCTIONS", value: 68)
!79 = !DIEnumerator(name: "_SC_GETGR_R_SIZE_MAX", value: 69)
!80 = !DIEnumerator(name: "_SC_GETPW_R_SIZE_MAX", value: 70)
!81 = !DIEnumerator(name: "_SC_LOGIN_NAME_MAX", value: 71)
!82 = !DIEnumerator(name: "_SC_TTY_NAME_MAX", value: 72)
!83 = !DIEnumerator(name: "_SC_THREAD_DESTRUCTOR_ITERATIONS", value: 73)
!84 = !DIEnumerator(name: "_SC_THREAD_KEYS_MAX", value: 74)
!85 = !DIEnumerator(name: "_SC_THREAD_STACK_MIN", value: 75)
!86 = !DIEnumerator(name: "_SC_THREAD_THREADS_MAX", value: 76)
!87 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKADDR", value: 77)
!88 = !DIEnumerator(name: "_SC_THREAD_ATTR_STACKSIZE", value: 78)
!89 = !DIEnumerator(name: "_SC_THREAD_PRIORITY_SCHEDULING", value: 79)
!90 = !DIEnumerator(name: "_SC_THREAD_PRIO_INHERIT", value: 80)
!91 = !DIEnumerator(name: "_SC_THREAD_PRIO_PROTECT", value: 81)
!92 = !DIEnumerator(name: "_SC_THREAD_PROCESS_SHARED", value: 82)
!93 = !DIEnumerator(name: "_SC_NPROCESSORS_CONF", value: 83)
!94 = !DIEnumerator(name: "_SC_NPROCESSORS_ONLN", value: 84)
!95 = !DIEnumerator(name: "_SC_PHYS_PAGES", value: 85)
!96 = !DIEnumerator(name: "_SC_AVPHYS_PAGES", value: 86)
!97 = !DIEnumerator(name: "_SC_ATEXIT_MAX", value: 87)
!98 = !DIEnumerator(name: "_SC_PASS_MAX", value: 88)
!99 = !DIEnumerator(name: "_SC_XOPEN_VERSION", value: 89)
!100 = !DIEnumerator(name: "_SC_XOPEN_XCU_VERSION", value: 90)
!101 = !DIEnumerator(name: "_SC_XOPEN_UNIX", value: 91)
!102 = !DIEnumerator(name: "_SC_XOPEN_CRYPT", value: 92)
!103 = !DIEnumerator(name: "_SC_XOPEN_ENH_I18N", value: 93)
!104 = !DIEnumerator(name: "_SC_XOPEN_SHM", value: 94)
!105 = !DIEnumerator(name: "_SC_2_CHAR_TERM", value: 95)
!106 = !DIEnumerator(name: "_SC_2_C_VERSION", value: 96)
!107 = !DIEnumerator(name: "_SC_2_UPE", value: 97)
!108 = !DIEnumerator(name: "_SC_XOPEN_XPG2", value: 98)
!109 = !DIEnumerator(name: "_SC_XOPEN_XPG3", value: 99)
!110 = !DIEnumerator(name: "_SC_XOPEN_XPG4", value: 100)
!111 = !DIEnumerator(name: "_SC_CHAR_BIT", value: 101)
!112 = !DIEnumerator(name: "_SC_CHAR_MAX", value: 102)
!113 = !DIEnumerator(name: "_SC_CHAR_MIN", value: 103)
!114 = !DIEnumerator(name: "_SC_INT_MAX", value: 104)
!115 = !DIEnumerator(name: "_SC_INT_MIN", value: 105)
!116 = !DIEnumerator(name: "_SC_LONG_BIT", value: 106)
!117 = !DIEnumerator(name: "_SC_WORD_BIT", value: 107)
!118 = !DIEnumerator(name: "_SC_MB_LEN_MAX", value: 108)
!119 = !DIEnumerator(name: "_SC_NZERO", value: 109)
!120 = !DIEnumerator(name: "_SC_SSIZE_MAX", value: 110)
!121 = !DIEnumerator(name: "_SC_SCHAR_MAX", value: 111)
!122 = !DIEnumerator(name: "_SC_SCHAR_MIN", value: 112)
!123 = !DIEnumerator(name: "_SC_SHRT_MAX", value: 113)
!124 = !DIEnumerator(name: "_SC_SHRT_MIN", value: 114)
!125 = !DIEnumerator(name: "_SC_UCHAR_MAX", value: 115)
!126 = !DIEnumerator(name: "_SC_UINT_MAX", value: 116)
!127 = !DIEnumerator(name: "_SC_ULONG_MAX", value: 117)
!128 = !DIEnumerator(name: "_SC_USHRT_MAX", value: 118)
!129 = !DIEnumerator(name: "_SC_NL_ARGMAX", value: 119)
!130 = !DIEnumerator(name: "_SC_NL_LANGMAX", value: 120)
!131 = !DIEnumerator(name: "_SC_NL_MSGMAX", value: 121)
!132 = !DIEnumerator(name: "_SC_NL_NMAX", value: 122)
!133 = !DIEnumerator(name: "_SC_NL_SETMAX", value: 123)
!134 = !DIEnumerator(name: "_SC_NL_TEXTMAX", value: 124)
!135 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFF32", value: 125)
!136 = !DIEnumerator(name: "_SC_XBS5_ILP32_OFFBIG", value: 126)
!137 = !DIEnumerator(name: "_SC_XBS5_LP64_OFF64", value: 127)
!138 = !DIEnumerator(name: "_SC_XBS5_LPBIG_OFFBIG", value: 128)
!139 = !DIEnumerator(name: "_SC_XOPEN_LEGACY", value: 129)
!140 = !DIEnumerator(name: "_SC_XOPEN_REALTIME", value: 130)
!141 = !DIEnumerator(name: "_SC_XOPEN_REALTIME_THREADS", value: 131)
!142 = !DIEnumerator(name: "_SC_ADVISORY_INFO", value: 132)
!143 = !DIEnumerator(name: "_SC_BARRIERS", value: 133)
!144 = !DIEnumerator(name: "_SC_BASE", value: 134)
!145 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT", value: 135)
!146 = !DIEnumerator(name: "_SC_C_LANG_SUPPORT_R", value: 136)
!147 = !DIEnumerator(name: "_SC_CLOCK_SELECTION", value: 137)
!148 = !DIEnumerator(name: "_SC_CPUTIME", value: 138)
!149 = !DIEnumerator(name: "_SC_THREAD_CPUTIME", value: 139)
!150 = !DIEnumerator(name: "_SC_DEVICE_IO", value: 140)
!151 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC", value: 141)
!152 = !DIEnumerator(name: "_SC_DEVICE_SPECIFIC_R", value: 142)
!153 = !DIEnumerator(name: "_SC_FD_MGMT", value: 143)
!154 = !DIEnumerator(name: "_SC_FIFO", value: 144)
!155 = !DIEnumerator(name: "_SC_PIPE", value: 145)
!156 = !DIEnumerator(name: "_SC_FILE_ATTRIBUTES", value: 146)
!157 = !DIEnumerator(name: "_SC_FILE_LOCKING", value: 147)
!158 = !DIEnumerator(name: "_SC_FILE_SYSTEM", value: 148)
!159 = !DIEnumerator(name: "_SC_MONOTONIC_CLOCK", value: 149)
!160 = !DIEnumerator(name: "_SC_MULTI_PROCESS", value: 150)
!161 = !DIEnumerator(name: "_SC_SINGLE_PROCESS", value: 151)
!162 = !DIEnumerator(name: "_SC_NETWORKING", value: 152)
!163 = !DIEnumerator(name: "_SC_READER_WRITER_LOCKS", value: 153)
!164 = !DIEnumerator(name: "_SC_SPIN_LOCKS", value: 154)
!165 = !DIEnumerator(name: "_SC_REGEXP", value: 155)
!166 = !DIEnumerator(name: "_SC_REGEX_VERSION", value: 156)
!167 = !DIEnumerator(name: "_SC_SHELL", value: 157)
!168 = !DIEnumerator(name: "_SC_SIGNALS", value: 158)
!169 = !DIEnumerator(name: "_SC_SPAWN", value: 159)
!170 = !DIEnumerator(name: "_SC_SPORADIC_SERVER", value: 160)
!171 = !DIEnumerator(name: "_SC_THREAD_SPORADIC_SERVER", value: 161)
!172 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE", value: 162)
!173 = !DIEnumerator(name: "_SC_SYSTEM_DATABASE_R", value: 163)
!174 = !DIEnumerator(name: "_SC_TIMEOUTS", value: 164)
!175 = !DIEnumerator(name: "_SC_TYPED_MEMORY_OBJECTS", value: 165)
!176 = !DIEnumerator(name: "_SC_USER_GROUPS", value: 166)
!177 = !DIEnumerator(name: "_SC_USER_GROUPS_R", value: 167)
!178 = !DIEnumerator(name: "_SC_2_PBS", value: 168)
!179 = !DIEnumerator(name: "_SC_2_PBS_ACCOUNTING", value: 169)
!180 = !DIEnumerator(name: "_SC_2_PBS_LOCATE", value: 170)
!181 = !DIEnumerator(name: "_SC_2_PBS_MESSAGE", value: 171)
!182 = !DIEnumerator(name: "_SC_2_PBS_TRACK", value: 172)
!183 = !DIEnumerator(name: "_SC_SYMLOOP_MAX", value: 173)
!184 = !DIEnumerator(name: "_SC_STREAMS", value: 174)
!185 = !DIEnumerator(name: "_SC_2_PBS_CHECKPOINT", value: 175)
!186 = !DIEnumerator(name: "_SC_V6_ILP32_OFF32", value: 176)
!187 = !DIEnumerator(name: "_SC_V6_ILP32_OFFBIG", value: 177)
!188 = !DIEnumerator(name: "_SC_V6_LP64_OFF64", value: 178)
!189 = !DIEnumerator(name: "_SC_V6_LPBIG_OFFBIG", value: 179)
!190 = !DIEnumerator(name: "_SC_HOST_NAME_MAX", value: 180)
!191 = !DIEnumerator(name: "_SC_TRACE", value: 181)
!192 = !DIEnumerator(name: "_SC_TRACE_EVENT_FILTER", value: 182)
!193 = !DIEnumerator(name: "_SC_TRACE_INHERIT", value: 183)
!194 = !DIEnumerator(name: "_SC_TRACE_LOG", value: 184)
!195 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_SIZE", value: 185)
!196 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_ASSOC", value: 186)
!197 = !DIEnumerator(name: "_SC_LEVEL1_ICACHE_LINESIZE", value: 187)
!198 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_SIZE", value: 188)
!199 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_ASSOC", value: 189)
!200 = !DIEnumerator(name: "_SC_LEVEL1_DCACHE_LINESIZE", value: 190)
!201 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_SIZE", value: 191)
!202 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_ASSOC", value: 192)
!203 = !DIEnumerator(name: "_SC_LEVEL2_CACHE_LINESIZE", value: 193)
!204 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_SIZE", value: 194)
!205 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_ASSOC", value: 195)
!206 = !DIEnumerator(name: "_SC_LEVEL3_CACHE_LINESIZE", value: 196)
!207 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_SIZE", value: 197)
!208 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_ASSOC", value: 198)
!209 = !DIEnumerator(name: "_SC_LEVEL4_CACHE_LINESIZE", value: 199)
!210 = !DIEnumerator(name: "_SC_IPV6", value: 235)
!211 = !DIEnumerator(name: "_SC_RAW_SOCKETS", value: 236)
!212 = !DIEnumerator(name: "_SC_V7_ILP32_OFF32", value: 237)
!213 = !DIEnumerator(name: "_SC_V7_ILP32_OFFBIG", value: 238)
!214 = !DIEnumerator(name: "_SC_V7_LP64_OFF64", value: 239)
!215 = !DIEnumerator(name: "_SC_V7_LPBIG_OFFBIG", value: 240)
!216 = !DIEnumerator(name: "_SC_SS_REPL_MAX", value: 241)
!217 = !DIEnumerator(name: "_SC_TRACE_EVENT_NAME_MAX", value: 242)
!218 = !DIEnumerator(name: "_SC_TRACE_NAME_MAX", value: 243)
!219 = !DIEnumerator(name: "_SC_TRACE_SYS_MAX", value: 244)
!220 = !DIEnumerator(name: "_SC_TRACE_USER_EVENT_MAX", value: 245)
!221 = !DIEnumerator(name: "_SC_XOPEN_STREAMS", value: 246)
!222 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_INHERIT", value: 247)
!223 = !DIEnumerator(name: "_SC_THREAD_ROBUST_PRIO_PROTECT", value: 248)
!224 = !DIEnumerator(name: "_SC_MINSIGSTKSZ", value: 249)
!225 = !DIEnumerator(name: "_SC_SIGSTKSZ", value: 250)
!226 = !{!227, !230, !232, !233}
!227 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !228, line: 46, baseType: !229)
!228 = !DIFile(filename: "/usr/lib/llvm-14/lib/clang/14.0.6/include/stddef.h", directory: "", checksumkind: CSK_MD5, checksum: "2499dd2361b915724b073282bea3a7bc")
!229 = !DIBasicType(name: "unsigned long", size: 64, encoding: DW_ATE_unsigned)
!230 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !231, size: 64)
!231 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!232 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!233 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !234, size: 64)
!234 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!235 = !{!0}
!236 = !DIFile(filename: "out/eval2_linux/harnesses/harness_kbmi_net_line71.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "dc433410b57f080815b1195167b330c6")
!237 = !DICompositeType(tag: DW_TAG_array_type, baseType: !234, size: 8192, elements: !238)
!238 = !{!239}
!239 = !DISubrange(count: 1024)
!240 = distinct !DICompileUnit(language: DW_LANG_C99, file: !241, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!241 = !DIFile(filename: "/home/shafi/tools/klee/runtime/Freestanding/memcpy.c", directory: "/home/shafi/tools/klee/build/runtime/Freestanding", checksumkind: CSK_MD5, checksum: "c636d77d986b2156da8c1ff12af1c5cd")
!242 = distinct !DICompileUnit(language: DW_LANG_C99, file: !243, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!243 = !DIFile(filename: "/home/shafi/tools/klee/runtime/Freestanding/memset.c", directory: "/home/shafi/tools/klee/build/runtime/Freestanding", checksumkind: CSK_MD5, checksum: "f66ef9ef9131ab198e93a41b1a9ae1fc")
!244 = !{i32 7, !"Dwarf Version", i32 5}
!245 = !{i32 2, !"Debug Info Version", i32 3}
!246 = !{i32 1, !"wchar_size", i32 4}
!247 = !{i32 7, !"PIC Level", i32 2}
!248 = !{i32 7, !"PIE Level", i32 2}
!249 = !{i32 7, !"uwtable", i32 1}
!250 = !{i32 7, !"frame-pointer", i32 2}
!251 = !{!"Ubuntu clang version 14.0.6"}
!252 = distinct !DISubprogram(name: "main", scope: !253, file: !253, line: 79, type: !254, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !257)
!253 = !DIFile(filename: "kbmi_net.c", directory: "/home/shafi/harden/eval3_demo/stase3")
!254 = !DISubroutineType(types: !255)
!255 = !{!256}
!256 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!257 = !{}
!258 = !DILocalVariable(name: "sep_pos", scope: !252, file: !253, line: 81, type: !227)
!259 = !DILocation(line: 81, column: 19, scope: !252)
!260 = !DILocalVariable(name: "shellcode_byte", scope: !252, file: !253, line: 82, type: !234)
!261 = !DILocation(line: 82, column: 19, scope: !252)
!262 = !DILocalVariable(name: "filler_byte", scope: !252, file: !253, line: 83, type: !234)
!263 = !DILocation(line: 83, column: 19, scope: !252)
!264 = !DILocation(line: 86, column: 24, scope: !252)
!265 = !DILocation(line: 86, column: 5, scope: !252)
!266 = !DILocation(line: 87, column: 5, scope: !252)
!267 = !DILocation(line: 88, column: 5, scope: !252)
!268 = !DILocation(line: 92, column: 17, scope: !252)
!269 = !DILocation(line: 92, column: 25, scope: !252)
!270 = !DILocation(line: 92, column: 5, scope: !252)
!271 = !DILocation(line: 93, column: 17, scope: !252)
!272 = !DILocation(line: 93, column: 32, scope: !252)
!273 = !DILocation(line: 93, column: 5, scope: !252)
!274 = !DILocation(line: 94, column: 17, scope: !252)
!275 = !DILocation(line: 94, column: 29, scope: !252)
!276 = !DILocation(line: 94, column: 5, scope: !252)
!277 = !DILocation(line: 101, column: 30, scope: !252)
!278 = !DILocation(line: 101, column: 5, scope: !252)
!279 = !DILocation(line: 102, column: 22, scope: !252)
!280 = !DILocation(line: 102, column: 5, scope: !252)
!281 = !DILocation(line: 102, column: 31, scope: !252)
!282 = !DILocation(line: 103, column: 37, scope: !252)
!283 = !DILocation(line: 103, column: 22, scope: !252)
!284 = !DILocation(line: 103, column: 30, scope: !252)
!285 = !DILocation(line: 103, column: 5, scope: !252)
!286 = !DILocation(line: 103, column: 35, scope: !252)
!287 = !DILocation(line: 105, column: 11, scope: !252)
!288 = !DILocation(line: 106, column: 5, scope: !252)
!289 = distinct !DISubprogram(name: "kbmi_pre_routing_hook", scope: !236, file: !236, line: 57, type: !290, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !257)
!290 = !DISubroutineType(types: !291)
!291 = !{!7, !233}
!292 = !DILocalVariable(name: "message_buffer", arg: 1, scope: !289, file: !236, line: 57, type: !233)
!293 = !DILocation(line: 57, column: 58, scope: !289)
!294 = !DILocalVariable(name: "code_segment", scope: !289, file: !236, line: 59, type: !237)
!295 = !DILocation(line: 59, column: 19, scope: !289)
!296 = !DILocalVariable(name: "ret", scope: !289, file: !236, line: 60, type: !256)
!297 = !DILocation(line: 60, column: 9, scope: !289)
!298 = !DILocation(line: 62, column: 10, scope: !299)
!299 = distinct !DILexicalBlock(scope: !289, file: !236, line: 62, column: 9)
!300 = !DILocation(line: 62, column: 9, scope: !289)
!301 = !DILocation(line: 63, column: 9, scope: !299)
!302 = !DILocalVariable(name: "message_separator", scope: !289, file: !236, line: 65, type: !230)
!303 = !DILocation(line: 65, column: 11, scope: !289)
!304 = !DILocation(line: 65, column: 46, scope: !289)
!305 = !DILocation(line: 65, column: 39, scope: !289)
!306 = !DILocation(line: 66, column: 9, scope: !307)
!307 = distinct !DILexicalBlock(scope: !289, file: !236, line: 66, column: 9)
!308 = !DILocation(line: 66, column: 27, scope: !307)
!309 = !DILocation(line: 66, column: 9, scope: !289)
!310 = !DILocation(line: 67, column: 9, scope: !307)
!311 = !DILocation(line: 69, column: 18, scope: !312)
!312 = distinct !DILexicalBlock(scope: !289, file: !236, line: 69, column: 9)
!313 = !DILocation(line: 69, column: 46, scope: !312)
!314 = !DILocation(line: 69, column: 36, scope: !312)
!315 = !DILocation(line: 69, column: 62, scope: !312)
!316 = !DILocation(line: 69, column: 9, scope: !289)
!317 = !DILocation(line: 70, column: 9, scope: !312)
!318 = !DILocalVariable(name: "code_start", scope: !289, file: !236, line: 73, type: !230)
!319 = !DILocation(line: 73, column: 11, scope: !289)
!320 = !DILocation(line: 73, column: 24, scope: !289)
!321 = !DILocation(line: 73, column: 42, scope: !289)
!322 = !DILocalVariable(name: "code_end", scope: !289, file: !236, line: 74, type: !230)
!323 = !DILocation(line: 74, column: 11, scope: !289)
!324 = !DILocation(line: 74, column: 30, scope: !289)
!325 = !DILocation(line: 74, column: 45, scope: !289)
!326 = !DILocalVariable(name: "code_size", scope: !289, file: !236, line: 75, type: !227)
!327 = !DILocation(line: 75, column: 12, scope: !289)
!328 = !DILocation(line: 75, column: 33, scope: !289)
!329 = !DILocation(line: 75, column: 44, scope: !289)
!330 = !DILocation(line: 75, column: 42, scope: !289)
!331 = !DILocation(line: 76, column: 9, scope: !332)
!332 = distinct !DILexicalBlock(scope: !289, file: !236, line: 76, column: 9)
!333 = !DILocation(line: 76, column: 19, scope: !332)
!334 = !DILocation(line: 76, column: 9, scope: !289)
!335 = !DILocation(line: 77, column: 9, scope: !332)
!336 = !DILocation(line: 78, column: 5, scope: !289)
!337 = !DILocation(line: 78, column: 26, scope: !289)
!338 = !DILocation(line: 78, column: 38, scope: !289)
!339 = !DILocalVariable(name: "pagesize", scope: !289, file: !236, line: 86, type: !340)
!340 = !DIBasicType(name: "long", size: 64, encoding: DW_ATE_signed)
!341 = !DILocation(line: 86, column: 10, scope: !289)
!342 = !DILocation(line: 86, column: 21, scope: !289)
!343 = !DILocation(line: 87, column: 9, scope: !344)
!344 = distinct !DILexicalBlock(scope: !289, file: !236, line: 87, column: 9)
!345 = !DILocation(line: 87, column: 18, scope: !344)
!346 = !DILocation(line: 87, column: 9, scope: !289)
!347 = !DILocation(line: 88, column: 18, scope: !344)
!348 = !DILocation(line: 88, column: 9, scope: !344)
!349 = !DILocalVariable(name: "exec_page", scope: !289, file: !236, line: 89, type: !232)
!350 = !DILocation(line: 89, column: 11, scope: !289)
!351 = !DILocation(line: 89, column: 42, scope: !289)
!352 = !DILocation(line: 89, column: 23, scope: !289)
!353 = !DILocation(line: 91, column: 9, scope: !354)
!354 = distinct !DILexicalBlock(scope: !289, file: !236, line: 91, column: 9)
!355 = !DILocation(line: 91, column: 19, scope: !354)
!356 = !DILocation(line: 91, column: 9, scope: !289)
!357 = !DILocalVariable(name: "to_copy", scope: !358, file: !236, line: 92, type: !227)
!358 = distinct !DILexicalBlock(scope: !354, file: !236, line: 91, column: 34)
!359 = !DILocation(line: 92, column: 16, scope: !358)
!360 = !DILocation(line: 92, column: 26, scope: !358)
!361 = !DILocation(line: 92, column: 46, scope: !358)
!362 = !DILocation(line: 92, column: 36, scope: !358)
!363 = !DILocation(line: 92, column: 57, scope: !358)
!364 = !DILocation(line: 92, column: 77, scope: !358)
!365 = !DILocation(line: 93, column: 16, scope: !358)
!366 = !DILocation(line: 93, column: 9, scope: !358)
!367 = !DILocation(line: 93, column: 41, scope: !358)
!368 = !DILocation(line: 94, column: 24, scope: !358)
!369 = !DILocation(line: 94, column: 43, scope: !358)
!370 = !DILocation(line: 94, column: 15, scope: !358)
!371 = !DILocation(line: 96, column: 22, scope: !358)
!372 = !DILocation(line: 96, column: 41, scope: !358)
!373 = !DILocation(line: 96, column: 15, scope: !358)
!374 = !DILocation(line: 97, column: 5, scope: !358)
!375 = !DILocalVariable(name: "sentinel", scope: !289, file: !236, line: 105, type: !233)
!376 = !DILocation(line: 105, column: 20, scope: !289)
!377 = !DILocation(line: 105, column: 48, scope: !289)
!378 = !DILocation(line: 106, column: 12, scope: !289)
!379 = !DILocation(line: 106, column: 5, scope: !289)
!380 = !DILocalVariable(name: "oob_idx", scope: !289, file: !236, line: 107, type: !227)
!381 = !DILocation(line: 107, column: 12, scope: !289)
!382 = !DILocation(line: 107, column: 44, scope: !289)
!383 = !DILocation(line: 107, column: 60, scope: !289)
!384 = !DILocation(line: 107, column: 35, scope: !289)
!385 = !DILocation(line: 107, column: 33, scope: !289)
!386 = !DILocalVariable(name: "trip", scope: !289, file: !236, line: 108, type: !387)
!387 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !234)
!388 = !DILocation(line: 108, column: 28, scope: !289)
!389 = !DILocation(line: 71, column: 12, scope: !390)
!390 = !DILexicalBlockFile(scope: !289, file: !253, discriminator: 0)
!391 = !DILocation(line: 71, column: 21, scope: !390)
!392 = !DILocation(line: 71, column: 10, scope: !390)
!393 = !DILocation(line: 72, column: 11, scope: !390)
!394 = !DILocation(line: 73, column: 10, scope: !390)
!395 = !DILocation(line: 73, column: 5, scope: !390)
!396 = !DILabel(scope: !390, name: "out", file: !253, line: 75)
!397 = !DILocation(line: 75, column: 1, scope: !390)
!398 = !DILocation(line: 76, column: 12, scope: !390)
!399 = !DILocation(line: 76, column: 5, scope: !390)
!400 = distinct !DISubprogram(name: "memcpy", scope: !401, file: !401, line: 12, type: !402, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !240, retainedNodes: !257)
!401 = !DIFile(filename: "runtime/Freestanding/memcpy.c", directory: "/home/shafi/tools/klee", checksumkind: CSK_MD5, checksum: "c636d77d986b2156da8c1ff12af1c5cd")
!402 = !DISubroutineType(types: !403)
!403 = !{!232, !232, !404, !227}
!404 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !405, size: 64)
!405 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!406 = !DILocalVariable(name: "destaddr", arg: 1, scope: !400, file: !401, line: 12, type: !232)
!407 = !DILocation(line: 12, column: 20, scope: !400)
!408 = !DILocalVariable(name: "srcaddr", arg: 2, scope: !400, file: !401, line: 12, type: !404)
!409 = !DILocation(line: 12, column: 42, scope: !400)
!410 = !DILocalVariable(name: "len", arg: 3, scope: !400, file: !401, line: 12, type: !227)
!411 = !DILocation(line: 12, column: 58, scope: !400)
!412 = !DILocalVariable(name: "dest", scope: !400, file: !401, line: 13, type: !230)
!413 = !DILocation(line: 13, column: 9, scope: !400)
!414 = !DILocation(line: 13, column: 16, scope: !400)
!415 = !DILocalVariable(name: "src", scope: !400, file: !401, line: 14, type: !416)
!416 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !417, size: 64)
!417 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !231)
!418 = !DILocation(line: 14, column: 15, scope: !400)
!419 = !DILocation(line: 14, column: 21, scope: !400)
!420 = !DILocation(line: 16, column: 3, scope: !400)
!421 = !DILocation(line: 16, column: 13, scope: !400)
!422 = !DILocation(line: 16, column: 16, scope: !400)
!423 = !DILocation(line: 17, column: 19, scope: !400)
!424 = !DILocation(line: 17, column: 15, scope: !400)
!425 = !DILocation(line: 17, column: 10, scope: !400)
!426 = !DILocation(line: 17, column: 13, scope: !400)
!427 = distinct !{!427, !420, !423, !428}
!428 = !{!"llvm.loop.mustprogress"}
!429 = !DILocation(line: 18, column: 10, scope: !400)
!430 = !DILocation(line: 18, column: 3, scope: !400)
!431 = distinct !DISubprogram(name: "memset", scope: !432, file: !432, line: 12, type: !433, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !242, retainedNodes: !257)
!432 = !DIFile(filename: "runtime/Freestanding/memset.c", directory: "/home/shafi/tools/klee", checksumkind: CSK_MD5, checksum: "f66ef9ef9131ab198e93a41b1a9ae1fc")
!433 = !DISubroutineType(types: !434)
!434 = !{!232, !232, !256, !227}
!435 = !DILocalVariable(name: "dst", arg: 1, scope: !431, file: !432, line: 12, type: !232)
!436 = !DILocation(line: 12, column: 20, scope: !431)
!437 = !DILocalVariable(name: "s", arg: 2, scope: !431, file: !432, line: 12, type: !256)
!438 = !DILocation(line: 12, column: 29, scope: !431)
!439 = !DILocalVariable(name: "count", arg: 3, scope: !431, file: !432, line: 12, type: !227)
!440 = !DILocation(line: 12, column: 39, scope: !431)
!441 = !DILocalVariable(name: "a", scope: !431, file: !432, line: 13, type: !230)
!442 = !DILocation(line: 13, column: 9, scope: !431)
!443 = !DILocation(line: 13, column: 13, scope: !431)
!444 = !DILocation(line: 14, column: 3, scope: !431)
!445 = !DILocation(line: 14, column: 15, scope: !431)
!446 = !DILocation(line: 14, column: 18, scope: !431)
!447 = !DILocation(line: 15, column: 12, scope: !431)
!448 = !DILocation(line: 15, column: 7, scope: !431)
!449 = !DILocation(line: 15, column: 10, scope: !431)
!450 = distinct !{!450, !444, !447, !428}
!451 = !DILocation(line: 16, column: 10, scope: !431)
!452 = !DILocation(line: 16, column: 3, scope: !431)
