#ifndef CHATMODEL_H
#define CHATMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include <QMutex>
#include "tdlibwrapper.h"

class ChatModel : public QAbstractListModel
{
    Q_OBJECT
public:
    ChatModel(TDLibWrapper *tdLibWrapper);
    ~ChatModel() override;

    virtual int rowCount(const QModelIndex&) const override;
    virtual QVariant data(const QModelIndex &index, int role) const override;
    virtual bool insertRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

    Q_INVOKABLE void initialize(const QVariantMap &chatInformation);
    Q_INVOKABLE void triggerLoadMoreHistory();

signals:
    void messagesReceived(const int &modelIndex);
    void messagesIncrementalUpdate(const int &modelIndex);
    void newMessageReceived();
    void unreadCountUpdated(const int &unreadCount);

public slots:
    void handleMessagesReceived(const QVariantList &messages);
    void handleNewMessageReceived(const QString &chatId, const QVariantMap &message);
    void handleChatReadInboxUpdated(const QString &chatId, const int &unreadCount);

private:

    TDLibWrapper *tdLibWrapper;
    QVariantList messages;
    QVariantList messagesToBeAdded;
    QVariantMap messageIndexMap;
    QMutex messagesMutex;
    QVariantMap chatInformation;
    QString chatId;
    bool inReload;
    bool inIncrementalUpdate;

    void insertMessages();
    QVariantMap enhanceMessage(const QVariantMap &message);
};

#endif // CHATMODEL_H