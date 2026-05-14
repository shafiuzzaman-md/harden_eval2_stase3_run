; ModuleID = 'out/eval2_linux/path_a/vnet_pktfilter_line320/harness.bc'
source_filename = "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_vnet_pktfilter_line320.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.nf_hook_ops = type { i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)*, i32, i32, i32 }
%struct.sk_buff = type opaque
%struct.nf_hook_state = type opaque

@.str = private unnamed_addr constant [8 x i8] c"do_exit\00", align 1
@.str.1 = private unnamed_addr constant [9 x i8] c"do_route\00", align 1
@nfho_ptr = internal global %struct.nf_hook_ops* null, align 8, !dbg !0
@hook_table = internal global %struct.nf_hook_ops** null, align 8, !dbg !27

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 noundef %0, i8** noundef %1) #0 !dbg !37 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !45, metadata !DIExpression()), !dbg !46
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !47, metadata !DIExpression()), !dbg !48
  %8 = load i32, i32* %4, align 4, !dbg !49
  %9 = load i8**, i8*** %5, align 8, !dbg !50
  call void @llvm.dbg.declare(metadata i32* %6, metadata !51, metadata !DIExpression()), !dbg !52
  call void @llvm.dbg.declare(metadata i32* %7, metadata !53, metadata !DIExpression()), !dbg !54
  %10 = bitcast i32* %6 to i8*, !dbg !55
  call void @klee_make_symbolic(i8* noundef %10, i64 noundef 4, i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0)), !dbg !56
  %11 = bitcast i32* %7 to i8*, !dbg !57
  call void @klee_make_symbolic(i8* noundef %11, i64 noundef 4, i8* noundef getelementptr inbounds ([9 x i8], [9 x i8]* @.str.1, i64 0, i64 0)), !dbg !58
  %12 = load i32, i32* %6, align 4, !dbg !59
  %13 = icmp eq i32 %12, 1, !dbg !60
  %14 = zext i1 %13 to i32, !dbg !60
  %15 = sext i32 %14 to i64, !dbg !59
  call void @klee_assume(i64 noundef %15), !dbg !61
  %16 = load i32, i32* %7, align 4, !dbg !62
  %17 = icmp eq i32 %16, 1, !dbg !63
  %18 = zext i1 %17 to i32, !dbg !63
  %19 = sext i32 %18 to i64, !dbg !62
  call void @klee_assume(i64 noundef %19), !dbg !64
  %20 = call i32 @packet_filter_init(), !dbg !65
  %21 = icmp ne i32 %20, 0, !dbg !67
  br i1 %21, label %22, label %23, !dbg !68

22:                                               ; preds = %2
  store i32 1, i32* %3, align 4, !dbg !69
  br label %33, !dbg !69

23:                                               ; preds = %2
  %24 = load i32, i32* %6, align 4, !dbg !70
  %25 = icmp eq i32 %24, 1, !dbg !72
  br i1 %25, label %26, label %27, !dbg !73

26:                                               ; preds = %23
  call void @packet_filter_exit(), !dbg !74
  br label %27, !dbg !74

27:                                               ; preds = %26, %23
  %28 = load i32, i32* %7, align 4, !dbg !75
  %29 = icmp eq i32 %28, 1, !dbg !77
  br i1 %29, label %30, label %32, !dbg !78

30:                                               ; preds = %27
  %31 = call i32 @route_one_packet(), !dbg !79
  br label %32, !dbg !79

32:                                               ; preds = %30, %27
  store i32 0, i32* %3, align 4, !dbg !80
  br label %33, !dbg !80

33:                                               ; preds = %32, %22
  %34 = load i32, i32* %3, align 4, !dbg !81
  ret i32 %34, !dbg !81
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare void @klee_make_symbolic(i8* noundef, i64 noundef, i8* noundef) #2

declare void @klee_assume(i64 noundef) #2

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @packet_filter_init() #0 !dbg !82 {
  %1 = alloca i32, align 4
  %2 = call noalias i8* @malloc(i64 noundef 24) #4, !dbg !85
  %3 = bitcast i8* %2 to %struct.nf_hook_ops*, !dbg !86
  store %struct.nf_hook_ops* %3, %struct.nf_hook_ops** @nfho_ptr, align 8, !dbg !87
  %4 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** @nfho_ptr, align 8, !dbg !88
  %5 = icmp ne %struct.nf_hook_ops* %4, null, !dbg !88
  br i1 %5, label %7, label %6, !dbg !90

6:                                                ; preds = %0
  store i32 -1, i32* %1, align 4, !dbg !91
  br label %18, !dbg !91

7:                                                ; preds = %0
  %8 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** @nfho_ptr, align 8, !dbg !92
  %9 = getelementptr inbounds %struct.nf_hook_ops, %struct.nf_hook_ops* %8, i32 0, i32 0, !dbg !93
  store i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)* @packet_filter_hook, i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)** %9, align 8, !dbg !94
  %10 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** @nfho_ptr, align 8, !dbg !95
  %11 = getelementptr inbounds %struct.nf_hook_ops, %struct.nf_hook_ops* %10, i32 0, i32 1, !dbg !96
  store i32 0, i32* %11, align 8, !dbg !97
  %12 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** @nfho_ptr, align 8, !dbg !98
  %13 = getelementptr inbounds %struct.nf_hook_ops, %struct.nf_hook_ops* %12, i32 0, i32 2, !dbg !99
  store i32 2, i32* %13, align 4, !dbg !100
  %14 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** @nfho_ptr, align 8, !dbg !101
  %15 = getelementptr inbounds %struct.nf_hook_ops, %struct.nf_hook_ops* %14, i32 0, i32 3, !dbg !102
  store i32 0, i32* %15, align 8, !dbg !103
  %16 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** @nfho_ptr, align 8, !dbg !104
  %17 = call i32 @hook_registry_register(%struct.nf_hook_ops* noundef %16), !dbg !105
  store i32 %17, i32* %1, align 4, !dbg !106
  br label %18, !dbg !106

18:                                               ; preds = %7, %6
  %19 = load i32, i32* %1, align 4, !dbg !107
  ret i32 %19, !dbg !107
}

; Function Attrs: noinline nounwind optnone uwtable
define internal void @packet_filter_exit() #0 !dbg !108 {
  %1 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** @nfho_ptr, align 8, !dbg !112
  %2 = bitcast %struct.nf_hook_ops* %1 to i8*, !dbg !112
  call void @free(i8* noundef %2) #4, !dbg !113
  ret void, !dbg !114
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @route_one_packet() #0 !dbg !115 {
  %1 = alloca %struct.nf_hook_ops*, align 8
  %2 = alloca i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)*, align 8
  call void @llvm.dbg.declare(metadata %struct.nf_hook_ops** %1, metadata !118, metadata !DIExpression()), !dbg !119
  %3 = load %struct.nf_hook_ops**, %struct.nf_hook_ops*** @hook_table, align 8, !dbg !120
  %4 = getelementptr inbounds %struct.nf_hook_ops*, %struct.nf_hook_ops** %3, i64 0, !dbg !120
  %5 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** %4, align 8, !dbg !120
  store %struct.nf_hook_ops* %5, %struct.nf_hook_ops** %1, align 8, !dbg !119
  call void @llvm.dbg.declare(metadata i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)** %2, metadata !121, metadata !DIExpression()), !dbg !123
  %6 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** %1, align 8, !dbg !124
  %7 = getelementptr inbounds %struct.nf_hook_ops, %struct.nf_hook_ops* %6, i32 0, i32 0, !dbg !125
  %8 = load i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)*, i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)** %7, align 8, !dbg !125
  store i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)* %8, i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)** %2, align 8, !dbg !123
  %9 = load i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)*, i32 (i8*, %struct.sk_buff*, %struct.nf_hook_state*)** %2, align 8, !dbg !126
  %10 = call i32 %9(i8* noundef null, %struct.sk_buff* noundef null, %struct.nf_hook_state* noundef null), !dbg !126
  ret i32 %10, !dbg !128
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64 noundef) #3

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @packet_filter_hook(i8* noundef %0, %struct.sk_buff* noundef %1, %struct.nf_hook_state* noundef %2) #0 !dbg !129 {
  %4 = alloca i8*, align 8
  %5 = alloca %struct.sk_buff*, align 8
  %6 = alloca %struct.nf_hook_state*, align 8
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !130, metadata !DIExpression()), !dbg !131
  store %struct.sk_buff* %1, %struct.sk_buff** %5, align 8
  call void @llvm.dbg.declare(metadata %struct.sk_buff** %5, metadata !132, metadata !DIExpression()), !dbg !133
  store %struct.nf_hook_state* %2, %struct.nf_hook_state** %6, align 8
  call void @llvm.dbg.declare(metadata %struct.nf_hook_state** %6, metadata !134, metadata !DIExpression()), !dbg !135
  %7 = load i8*, i8** %4, align 8, !dbg !136
  %8 = load %struct.sk_buff*, %struct.sk_buff** %5, align 8, !dbg !137
  %9 = load %struct.nf_hook_state*, %struct.nf_hook_state** %6, align 8, !dbg !138
  ret i32 0, !dbg !139
}

; Function Attrs: noinline nounwind optnone uwtable
define internal i32 @hook_registry_register(%struct.nf_hook_ops* noundef %0) #0 !dbg !140 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.nf_hook_ops*, align 8
  %4 = alloca i32, align 4
  store %struct.nf_hook_ops* %0, %struct.nf_hook_ops** %3, align 8
  call void @llvm.dbg.declare(metadata %struct.nf_hook_ops** %3, metadata !143, metadata !DIExpression()), !dbg !144
  %5 = load %struct.nf_hook_ops**, %struct.nf_hook_ops*** @hook_table, align 8, !dbg !145
  %6 = icmp ne %struct.nf_hook_ops** %5, null, !dbg !145
  br i1 %6, label %10, label %7, !dbg !147

7:                                                ; preds = %1
  %8 = call noalias i8* @calloc(i64 noundef 4, i64 noundef 8) #4, !dbg !148
  %9 = bitcast i8* %8 to %struct.nf_hook_ops**, !dbg !149
  store %struct.nf_hook_ops** %9, %struct.nf_hook_ops*** @hook_table, align 8, !dbg !150
  br label %10, !dbg !151

10:                                               ; preds = %7, %1
  %11 = load %struct.nf_hook_ops**, %struct.nf_hook_ops*** @hook_table, align 8, !dbg !152
  %12 = icmp ne %struct.nf_hook_ops** %11, null, !dbg !152
  br i1 %12, label %14, label %13, !dbg !154

13:                                               ; preds = %10
  store i32 -1, i32* %2, align 4, !dbg !155
  br label %36, !dbg !155

14:                                               ; preds = %10
  call void @llvm.dbg.declare(metadata i32* %4, metadata !156, metadata !DIExpression()), !dbg !158
  store i32 0, i32* %4, align 4, !dbg !158
  br label %15, !dbg !159

15:                                               ; preds = %32, %14
  %16 = load i32, i32* %4, align 4, !dbg !160
  %17 = icmp slt i32 %16, 4, !dbg !162
  br i1 %17, label %18, label %35, !dbg !163

18:                                               ; preds = %15
  %19 = load %struct.nf_hook_ops**, %struct.nf_hook_ops*** @hook_table, align 8, !dbg !164
  %20 = load i32, i32* %4, align 4, !dbg !167
  %21 = sext i32 %20 to i64, !dbg !164
  %22 = getelementptr inbounds %struct.nf_hook_ops*, %struct.nf_hook_ops** %19, i64 %21, !dbg !164
  %23 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** %22, align 8, !dbg !164
  %24 = icmp ne %struct.nf_hook_ops* %23, null, !dbg !164
  br i1 %24, label %31, label %25, !dbg !168

25:                                               ; preds = %18
  %26 = load %struct.nf_hook_ops*, %struct.nf_hook_ops** %3, align 8, !dbg !169
  %27 = load %struct.nf_hook_ops**, %struct.nf_hook_ops*** @hook_table, align 8, !dbg !171
  %28 = load i32, i32* %4, align 4, !dbg !172
  %29 = sext i32 %28 to i64, !dbg !171
  %30 = getelementptr inbounds %struct.nf_hook_ops*, %struct.nf_hook_ops** %27, i64 %29, !dbg !171
  store %struct.nf_hook_ops* %26, %struct.nf_hook_ops** %30, align 8, !dbg !173
  store i32 0, i32* %2, align 4, !dbg !174
  br label %36, !dbg !174

31:                                               ; preds = %18
  br label %32, !dbg !175

32:                                               ; preds = %31
  %33 = load i32, i32* %4, align 4, !dbg !176
  %34 = add nsw i32 %33, 1, !dbg !176
  store i32 %34, i32* %4, align 4, !dbg !176
  br label %15, !dbg !177, !llvm.loop !178

35:                                               ; preds = %15
  store i32 -1, i32* %2, align 4, !dbg !181
  br label %36, !dbg !181

36:                                               ; preds = %35, %25, %13
  %37 = load i32, i32* %2, align 4, !dbg !182
  ret i32 %37, !dbg !182
}

; Function Attrs: nounwind
declare noalias i8* @calloc(i64 noundef, i64 noundef) #3

; Function Attrs: nounwind
declare void @free(i8* noundef) #3

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!29, !30, !31, !32, !33, !34, !35}
!llvm.ident = !{!36}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "nfho_ptr", scope: !2, file: !7, line: 111, type: !5, isLocal: true, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.6", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, retainedTypes: !4, globals: !26, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/shafi/harden/eval3_demo/stase3/out/eval2_linux/harnesses/harness_vnet_pktfilter_line320.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "7bda2b67120363f352091fb7012f6d91")
!4 = !{!5, !25, !15, !16, !18}
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "nf_hook_ops", file: !7, line: 69, size: 192, elements: !8)
!7 = !DIFile(filename: "out/eval2_linux/harnesses/harness_vnet_pktfilter_line320.c", directory: "/home/shafi/harden/eval3_demo/stase3", checksumkind: CSK_MD5, checksum: "7bda2b67120363f352091fb7012f6d91")
!8 = !{!9, !21, !23, !24}
!9 = !DIDerivedType(tag: DW_TAG_member, name: "hook", scope: !6, file: !7, line: 70, baseType: !10, size: 64)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "nf_hookfn", file: !7, line: 65, baseType: !11)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DISubroutineType(types: !13)
!13 = !{!14, !15, !16, !18}
!14 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = !DICompositeType(tag: DW_TAG_structure_type, name: "sk_buff", file: !7, line: 62, flags: DIFlagFwdDecl)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!20 = !DICompositeType(tag: DW_TAG_structure_type, name: "nf_hook_state", file: !7, line: 63, flags: DIFlagFwdDecl)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "hooknum", scope: !6, file: !7, line: 71, baseType: !22, size: 32, offset: 64)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "pf", scope: !6, file: !7, line: 72, baseType: !22, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !6, file: !7, line: 73, baseType: !22, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!26 = !{!0, !27}
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "hook_table", scope: !2, file: !7, line: 83, type: !25, isLocal: true, isDefinition: true)
!29 = !{i32 7, !"Dwarf Version", i32 5}
!30 = !{i32 2, !"Debug Info Version", i32 3}
!31 = !{i32 1, !"wchar_size", i32 4}
!32 = !{i32 7, !"PIC Level", i32 2}
!33 = !{i32 7, !"PIE Level", i32 2}
!34 = !{i32 7, !"uwtable", i32 1}
!35 = !{i32 7, !"frame-pointer", i32 2}
!36 = !{!"Ubuntu clang version 14.0.6"}
!37 = distinct !DISubprogram(name: "main", scope: !38, file: !38, line: 154, type: !39, scopeLine: 155, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !44)
!38 = !DIFile(filename: "harness.c", directory: "/home/shafi/harden/eval3_demo/stase3")
!39 = !DISubroutineType(types: !40)
!40 = !{!22, !22, !41}
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!44 = !{}
!45 = !DILocalVariable(name: "argc", arg: 1, scope: !37, file: !38, line: 154, type: !22)
!46 = !DILocation(line: 154, column: 14, scope: !37)
!47 = !DILocalVariable(name: "argv", arg: 2, scope: !37, file: !38, line: 154, type: !41)
!48 = !DILocation(line: 154, column: 27, scope: !37)
!49 = !DILocation(line: 156, column: 11, scope: !37)
!50 = !DILocation(line: 156, column: 23, scope: !37)
!51 = !DILocalVariable(name: "do_exit", scope: !37, file: !38, line: 158, type: !14)
!52 = !DILocation(line: 158, column: 18, scope: !37)
!53 = !DILocalVariable(name: "do_route", scope: !37, file: !38, line: 159, type: !14)
!54 = !DILocation(line: 159, column: 18, scope: !37)
!55 = !DILocation(line: 162, column: 24, scope: !37)
!56 = !DILocation(line: 162, column: 5, scope: !37)
!57 = !DILocation(line: 163, column: 24, scope: !37)
!58 = !DILocation(line: 163, column: 5, scope: !37)
!59 = !DILocation(line: 164, column: 17, scope: !37)
!60 = !DILocation(line: 164, column: 26, scope: !37)
!61 = !DILocation(line: 164, column: 5, scope: !37)
!62 = !DILocation(line: 165, column: 17, scope: !37)
!63 = !DILocation(line: 165, column: 26, scope: !37)
!64 = !DILocation(line: 165, column: 5, scope: !37)
!65 = !DILocation(line: 171, column: 9, scope: !66)
!66 = distinct !DILexicalBlock(scope: !37, file: !38, line: 171, column: 9)
!67 = !DILocation(line: 171, column: 30, scope: !66)
!68 = !DILocation(line: 171, column: 9, scope: !37)
!69 = !DILocation(line: 172, column: 9, scope: !66)
!70 = !DILocation(line: 174, column: 9, scope: !71)
!71 = distinct !DILexicalBlock(scope: !37, file: !38, line: 174, column: 9)
!72 = !DILocation(line: 174, column: 17, scope: !71)
!73 = !DILocation(line: 174, column: 9, scope: !37)
!74 = !DILocation(line: 175, column: 9, scope: !71)
!75 = !DILocation(line: 177, column: 9, scope: !76)
!76 = distinct !DILexicalBlock(scope: !37, file: !38, line: 177, column: 9)
!77 = !DILocation(line: 177, column: 18, scope: !76)
!78 = !DILocation(line: 177, column: 9, scope: !37)
!79 = !DILocation(line: 178, column: 9, scope: !76)
!80 = !DILocation(line: 180, column: 5, scope: !37)
!81 = !DILocation(line: 181, column: 1, scope: !37)
!82 = distinct !DISubprogram(name: "packet_filter_init", scope: !7, file: !7, line: 113, type: !83, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !44)
!83 = !DISubroutineType(types: !84)
!84 = !{!22}
!85 = !DILocation(line: 115, column: 38, scope: !82)
!86 = !DILocation(line: 115, column: 16, scope: !82)
!87 = !DILocation(line: 115, column: 14, scope: !82)
!88 = !DILocation(line: 116, column: 10, scope: !89)
!89 = distinct !DILexicalBlock(scope: !82, file: !7, line: 116, column: 9)
!90 = !DILocation(line: 116, column: 9, scope: !82)
!91 = !DILocation(line: 117, column: 9, scope: !89)
!92 = !DILocation(line: 118, column: 5, scope: !82)
!93 = !DILocation(line: 118, column: 15, scope: !82)
!94 = !DILocation(line: 118, column: 24, scope: !82)
!95 = !DILocation(line: 119, column: 5, scope: !82)
!96 = !DILocation(line: 119, column: 15, scope: !82)
!97 = !DILocation(line: 119, column: 24, scope: !82)
!98 = !DILocation(line: 120, column: 5, scope: !82)
!99 = !DILocation(line: 120, column: 15, scope: !82)
!100 = !DILocation(line: 120, column: 24, scope: !82)
!101 = !DILocation(line: 121, column: 5, scope: !82)
!102 = !DILocation(line: 121, column: 15, scope: !82)
!103 = !DILocation(line: 121, column: 24, scope: !82)
!104 = !DILocation(line: 123, column: 35, scope: !82)
!105 = !DILocation(line: 123, column: 12, scope: !82)
!106 = !DILocation(line: 123, column: 5, scope: !82)
!107 = !DILocation(line: 124, column: 1, scope: !82)
!108 = distinct !DISubprogram(name: "packet_filter_exit", scope: !109, file: !109, line: 318, type: !110, scopeLine: 319, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !44)
!109 = !DIFile(filename: "vnet_pktfilter.c", directory: "/home/shafi/harden/eval3_demo/stase3")
!110 = !DISubroutineType(types: !111)
!111 = !{null}
!112 = !DILocation(line: 320, column: 10, scope: !108)
!113 = !DILocation(line: 320, column: 5, scope: !108)
!114 = !DILocation(line: 321, column: 1, scope: !108)
!115 = distinct !DISubprogram(name: "route_one_packet", scope: !38, file: !38, line: 145, type: !116, scopeLine: 146, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !44)
!116 = !DISubroutineType(types: !117)
!117 = !{!14}
!118 = !DILocalVariable(name: "ops", scope: !115, file: !38, line: 147, type: !5)
!119 = !DILocation(line: 147, column: 25, scope: !115)
!120 = !DILocation(line: 147, column: 31, scope: !115)
!121 = !DILocalVariable(name: "fn", scope: !122, file: !109, line: 320, type: !10)
!122 = !DILexicalBlockFile(scope: !115, file: !109, discriminator: 0)
!123 = !DILocation(line: 320, column: 15, scope: !122)
!124 = !DILocation(line: 320, column: 20, scope: !122)
!125 = !DILocation(line: 320, column: 25, scope: !122)
!126 = !DILocation(line: 148, column: 12, scope: !127)
!127 = !DILexicalBlockFile(scope: !115, file: !38, discriminator: 0)
!128 = !DILocation(line: 148, column: 5, scope: !127)
!129 = distinct !DISubprogram(name: "packet_filter_hook", scope: !7, file: !7, line: 101, type: !12, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !44)
!130 = !DILocalVariable(name: "priv", arg: 1, scope: !129, file: !7, line: 101, type: !15)
!131 = !DILocation(line: 101, column: 46, scope: !129)
!132 = !DILocalVariable(name: "skb", arg: 2, scope: !129, file: !7, line: 102, type: !16)
!133 = !DILocation(line: 102, column: 56, scope: !129)
!134 = !DILocalVariable(name: "state", arg: 3, scope: !129, file: !7, line: 103, type: !18)
!135 = !DILocation(line: 103, column: 68, scope: !129)
!136 = !DILocation(line: 105, column: 11, scope: !129)
!137 = !DILocation(line: 105, column: 23, scope: !129)
!138 = !DILocation(line: 105, column: 34, scope: !129)
!139 = !DILocation(line: 106, column: 5, scope: !129)
!140 = distinct !DISubprogram(name: "hook_registry_register", scope: !7, file: !7, line: 85, type: !141, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !2, retainedNodes: !44)
!141 = !DISubroutineType(types: !142)
!142 = !{!22, !5}
!143 = !DILocalVariable(name: "ops", arg: 1, scope: !140, file: !7, line: 85, type: !5)
!144 = !DILocation(line: 85, column: 55, scope: !140)
!145 = !DILocation(line: 87, column: 10, scope: !146)
!146 = distinct !DILexicalBlock(scope: !140, file: !7, line: 87, column: 9)
!147 = !DILocation(line: 87, column: 9, scope: !140)
!148 = !DILocation(line: 88, column: 45, scope: !146)
!149 = !DILocation(line: 88, column: 22, scope: !146)
!150 = !DILocation(line: 88, column: 20, scope: !146)
!151 = !DILocation(line: 88, column: 9, scope: !146)
!152 = !DILocation(line: 90, column: 10, scope: !153)
!153 = distinct !DILexicalBlock(scope: !140, file: !7, line: 90, column: 9)
!154 = !DILocation(line: 90, column: 9, scope: !140)
!155 = !DILocation(line: 91, column: 9, scope: !153)
!156 = !DILocalVariable(name: "i", scope: !157, file: !7, line: 92, type: !22)
!157 = distinct !DILexicalBlock(scope: !140, file: !7, line: 92, column: 5)
!158 = !DILocation(line: 92, column: 14, scope: !157)
!159 = !DILocation(line: 92, column: 10, scope: !157)
!160 = !DILocation(line: 92, column: 21, scope: !161)
!161 = distinct !DILexicalBlock(scope: !157, file: !7, line: 92, column: 5)
!162 = !DILocation(line: 92, column: 23, scope: !161)
!163 = !DILocation(line: 92, column: 5, scope: !157)
!164 = !DILocation(line: 93, column: 14, scope: !165)
!165 = distinct !DILexicalBlock(scope: !166, file: !7, line: 93, column: 13)
!166 = distinct !DILexicalBlock(scope: !161, file: !7, line: 92, column: 47)
!167 = !DILocation(line: 93, column: 25, scope: !165)
!168 = !DILocation(line: 93, column: 13, scope: !166)
!169 = !DILocation(line: 93, column: 47, scope: !170)
!170 = distinct !DILexicalBlock(scope: !165, file: !7, line: 93, column: 29)
!171 = !DILocation(line: 93, column: 31, scope: !170)
!172 = !DILocation(line: 93, column: 42, scope: !170)
!173 = !DILocation(line: 93, column: 45, scope: !170)
!174 = !DILocation(line: 93, column: 52, scope: !170)
!175 = !DILocation(line: 94, column: 5, scope: !166)
!176 = !DILocation(line: 92, column: 43, scope: !161)
!177 = !DILocation(line: 92, column: 5, scope: !161)
!178 = distinct !{!178, !163, !179, !180}
!179 = !DILocation(line: 94, column: 5, scope: !157)
!180 = !{!"llvm.loop.mustprogress"}
!181 = !DILocation(line: 95, column: 5, scope: !140)
!182 = !DILocation(line: 96, column: 1, scope: !140)
