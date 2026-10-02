<section class="page-title">
    <div class="container">
        <h1 class="title">{{ t._('Message Details') }}</h1>
    </div>
</section>

{{ partial('account/menu') }}



<section class="page-support-details">
    <div class="container">

                        {{ content() }}
                        {{ flashSession.output() }}


        <div class="page-support-details-inner internal-page">
            <div class="page-content">
                <div class="data-group">
                    <div class="internal-page-title">
                        <h2 class="title">{{ t._('Details') }}</h2>
                    </div>
                    <div class="support-info">
                        <ul class="support-details">
                            <li class="detail-info"><span class="detail-info-title">{{ t._('number_helpdesk') }}:</span> #<?php echo str_pad($helpdesk->id, 4, "0", STR_PAD_LEFT);?></li>
                            <li class="detail-info"><span class="detail-info-title">{{ t._('name') }}:</span> {{ helpdesk.name }}</li>
                            <li class="detail-info"><span class="detail-info-title">{{ t._('email') }}:</span> {{ helpdesk.email }}</li>

                            <?php if ( $helpdesk->id_event ) : ?>
                            <li class="detail-info"><span class="detail-info-title">{{ t._('Event') }}:</span> <?php echo $this->getDI()->getFormatdates()->format($helpdesk->Events->date_start, '25/Jan/2000');?> {{ helpdesk.Events.name }}</li>
                            <?php endif ; ?>


                            <li class="detail-info"><span class="detail-info-title">{{ t._('subject') }}:</span> {{ helpdesk.subject }}</li>
                            <li class="detail-info"><span class="detail-info-title">{{ t._('created_at') }}:</span> <?php echo $this->getDI()->getFormatdates()->format($helpdesk->created_at, '25/01/2000 17:00h');?></li>
                        </ul>
                    </div>
                </div>

                <div class="data-group">
                    <div class="internal-page-title">
                        <h2 class="title">{{ t._('interactions') }}</h2>
                    </div>
                    <div class="messages-table">
                        <table class="table table-striped table-messages">
                            <thead class="table-header">
                                <tr class="table-header-message">
                                    <th class="date">{{ t._('date') }}</th>
                                    <th class="author">{{ t._('author') }}</th>
                                    <th class="message">{{ t._('message') }}</th>
                                </tr>
                            </thead>
                            <tbody class="messages">
                                <?php foreach ( $helpdesk->HelpdeskAnswers AS $answers ) : ?>
                                <tr class="message">
                                    <td class="date"><?php echo $this->getDI()->getFormatdates()->format($answers->created_at, '25/01/2000 17:00h') ?></td>
                                    <td class="author">
                                        <?php if ( $answers->admin > 0 ) : ?>
                                            {{ config.company.name }}
                                        <?php else : ?>
                                            {{ answers.author }}
                                        <?php endif ; ?>
                                    </td>
                                    <td class="message" style="word-break: break-word;">{{ answers.message|nl2br }}</td>
                                </tr>
                                <?php endforeach ; ?>
                            </tbody>
                        </table>
                        <form class="form form-new-message" method="POST" action="{{ url() }}account/helpdesk/{{ helpdesk.id }}/#last">
                            <div class="form-group">
                                <label for="message">{{ t._('label_for_new_message_in_helpdesk') }}</label>
                                <textarea class="form-control" name="message" rows="3" placeholder="{{ t._('new_message') }}"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">{{ t._('send_new_message') }}</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>