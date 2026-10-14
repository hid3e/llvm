#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
using namespace llvm;

struct MyModPass : public PassInfoMixin<MyModPass> {
  PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
    LLVMContext &Ctx = M.getContext();
    IRBuilder<> builder(Ctx);
    Type *voidTy = Type::getVoidTy(Ctx);
    Type *int8PtrTy = Type::getInt8Ty(Ctx)->getPointerTo();
    ArrayRef<Type *> params = {int8PtrTy, int8PtrTy};
    FunctionType *logType = FunctionType::get(voidTy, params, false);
    FunctionCallee logFunc = M.getOrInsertFunction("traceLogger", logType);

    for (auto &F : M) {
      if (F.isDeclaration() || F.getName() == "traceLogger")
        continue;
      for (auto &B : F)
        for (auto &I : B) {
          if (isa<PHINode>(&I))
            continue;
          builder.SetInsertPoint(&I);
          Value *user = builder.CreateGlobalStringPtr(I.getOpcodeName());
          for (auto &U : I.operands()) {
            auto *op = dyn_cast<Instruction>(U.get());
            if (!op)
              continue;
            if (auto *phi = dyn_cast<PHINode>(op)) {
              for (auto &PU : phi->incoming_values()) {
                auto *pop = dyn_cast<Instruction>(PU.get());
                if (!pop || isa<PHINode>(pop))
                  continue;
                Value *name =
                    builder.CreateGlobalStringPtr(pop->getOpcodeName());
                Value *args[] = {user, name};
                builder.CreateCall(logFunc, args);
              }
            } else {
              Value *name = builder.CreateGlobalStringPtr(op->getOpcodeName());
              Value *args[] = {user, name};
              builder.CreateCall(logFunc, args);
            }
          }
        }
    }
    return PreservedAnalyses::none();
  };
};

PassPluginLibraryInfo getPassPluginInfo() {
  const auto callback = [](PassBuilder &PB) {
    PB.registerOptimizerLastEPCallback([](ModulePassManager &MPM, auto) {
      MPM.addPass(MyModPass{});
      return true;
    });
  };

  return {LLVM_PLUGIN_API_VERSION, "TracePass", "0.0.1", callback};
};

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return getPassPluginInfo();
}
