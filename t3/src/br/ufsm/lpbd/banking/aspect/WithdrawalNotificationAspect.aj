package br.ufsm.lpbd.banking.aspect;

import br.ufsm.lpbd.banking.core.Account;

// Exercicio 5.1
public aspect WithdrawalNotificationAspect {
	
    pointcut withdrawalExecution(Account account, float amount) :
        call(* Account.debit(float)) && args(amount) && target(account);

	before(Account account, float amount) : withdrawalExecution(account, amount) {
		if(amount > 10000.00) {
		    System.out.println("Notificação: Retirada de R$" + amount + " da conta " + account.getAccountNumber() +
                            " excede R$ 10,000.00. Notifique o administrador do sistema.");
		}
	}
}
